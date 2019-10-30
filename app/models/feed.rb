class Feed < ActiveRecord::Base
  has_many :feed_items

  def self.update_feeds
    # IMPORTANT: disable threads while developing otherwise you won't see output/errors
    require 'open-uri' # require gems here in order not to slow loading if functionality isn't used. Do not move inside update_feed as it needs to run outside the thread
    require 'nokogiri'
    Thread.new do
      feeds_updated = false
      Feed.all.each do |feed|
        if feed.feed_requested_at.blank? || (feed.feed_requested_at + feed.update_interval.to_i.seconds < Time.now)
          feed.update_feed
          feeds_updated = true
        end
      end

      # keep only the most recent n feed items, and delete the older items
      max_feed_items = 1000
      Feed.connection.execute("DELETE feed_items FROM feed_items JOIN (SELECT id FROM feed_items ORDER BY published_at DESC LIMIT #{max_feed_items},999999999) AS t2 ON feed_items.id = t2.id") if feeds_updated
    end
  end

  def update_feed
    self.update_attribute(:feed_requested_at, Time.now)
    xml = open(self.url, 'r', :read_timeout => 10).read
    return false if xml.blank?

    doc = Nokogiri::XML(xml)
    if self.format == 'rss'
      doc.search('channel item').each do |entry|
        entry_id = entry.at('guid').text.to_s
        next if FeedItem.find_by_entry_id(entry_id) # skip existing entries
        FeedItem.create(:feed_id => self.id, :entry_id => entry_id, :title => entry.at('title').text, :link => entry.at('link').text,
                        :summary => entry.at('description').text, :published_at => Time.parse(entry.at('pubDate').text))
      end
    end
  end

end
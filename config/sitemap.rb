require 'rubygems'
require 'sitemap_generator'

url_base = 'http://hyc.ie'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = url_base

SitemapGenerator::Sitemap.create do
  add root_path, :changefreq => 'daily', :priority => 0.9
  add contact_us_path, :changefreq => 'monthly', :priority => 0.5
  add '/sitemap', :changefreq => 'monthly', :priority => 0.5
  add social_path, :changefreq => 'daily', :priority => 0.5
  add social_events_path, :changefreq => 'daily', :priority => 0.5
  add junior_path, :changefreq => 'daily', :priority => 0.5
  add news_items_path, :changefreq => 'daily', :priority => 0.5
  add '/club-racing', :changefreq => 'daily', :priority => 0.5
  add contacts_path, :changefreq => 'daily', :priority => 0.5
  add gallery_categories_path, :changefreq => 'daily', :priority => 0.5
  add trophy_winners_path, :changefreq => 'monthly', :priority => 0.5
  add url_for(:controller => 'events', :action => :index, :event_type => 'open', :only_path => true), :changefreq => 'daily', :priority => 0.5
  add url_for(:controller => 'events', :action => :index, :event_type => 'club', :only_path => true), :changefreq => 'daily', :priority => 0.5
  add '/results', :changefreq => 'daily', :priority => 0.5
  add '/pay-now', :changefreq => 'monthly', :priority => 0.5

  NewsItem.find_each do |news_item|
    add news_item_path(news_item), :lastmod => news_item.updated_at
  end

  Page.find_each do |page|
    add page.url, :lastmod => page.updated_at
  end

  add bs_ads_path, :changefreq => 'daily', :priority => 0.5
  BsAd.active.find_each do |bs_ad|
    add bs_ad_path(bs_ad), :lastmod => bs_ad.updated_at
  end

  add crew_finder_ads_path, :changefreq => 'daily', :priority => 0.5
  CrewFinderAd.active.find_each do |crew_finder_ad|
    add crew_finder_ad_path(crew_finder_ad), :lastmod => crew_finder_ad.updated_at
  end

  add gallery_categories_path, :changefreq => 'daily', :priority => 0.5
  GalleryCategory.find_each do |category|
    add gallery_category_path(category), :lastmod => category.updated_at
  end

  GalleryAlbum.find_each do |gallery_album|
    add gallery_album_gallery_photos_path(gallery_album), :lastmod => gallery_album.updated_at
  end
end
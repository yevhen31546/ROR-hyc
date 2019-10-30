class CreateFeedItems < ActiveRecord::Migration
  def self.up
    create_table :feed_items do |t|
      t.string :feed_id
      t.string :entry_id
      t.string :title
      t.string :link
      t.text :summary
      t.datetime :published_at
      t.timestamps
    end
    add_index :feed_items, :feed_id
    add_index :feed_items, :published_at
    add_index :feed_items, :entry_id, :unique => true
  end

  def self.down
    drop_table :feed_items
  end
end
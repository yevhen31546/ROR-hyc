class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :url
      t.string :format
      t.integer :update_interval, :default => 600  # 10 minutes
      t.datetime :feed_requested_at
      t.timestamps
    end
    add_index :feeds, :created_at
    add_index :feeds, :updated_at
  end

  def self.down
    drop_table :feeds
  end
end
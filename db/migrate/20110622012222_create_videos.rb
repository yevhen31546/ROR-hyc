class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.timestamps
    end
    add_index :videos, :created_at
  end

  def self.down
    drop_table :feeds
  end
end
class CreateNewsItems < ActiveRecord::Migration
  def self.up
    create_table :news_items do |t|
      t.string :title
      t.text :content, :limit => 1.megabyte

      t.string :image_file_name
      t.integer :image_file_size
      t.string :image_content_type
      t.datetime :image_updated_at

      t.timestamps
    end

    add_index :news_items, :created_at
  end


  def self.down
    drop_table :news_items
  end
end

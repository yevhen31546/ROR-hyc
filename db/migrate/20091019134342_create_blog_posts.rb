class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :blog_posts do |t|
      t.string :title
      t.text :content, :limit => 1.megabyte
      t.string :author
      t.integer :blog_category_id

      t.string :image_file_name
      t.integer :image_file_size
      t.string :image_content_type
      t.datetime :image_updated_at

      t.timestamps
    end

    add_index :blog_posts, :blog_category_id
    add_index :blog_posts, :created_at
  end

  def self.down
    drop_table :blog_posts
  end
end

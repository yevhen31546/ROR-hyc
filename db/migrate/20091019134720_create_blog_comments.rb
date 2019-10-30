class CreateBlogComments < ActiveRecord::Migration
  def self.up
    create_table :blog_comments do |t|
      t.integer :blog_post_id
      t.string :author
      t.string :email
      t.text :comment
      t.string :status
      t.string :ip

      t.timestamps
    end

    add_index :blog_comments, :blog_post_id
    add_index :blog_comments, :created_at
    add_index :blog_comments, :status
  end

  def self.down
    drop_table :blog_comments
  end
end

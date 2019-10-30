class CreateGalleryAlbums < ActiveRecord::Migration
  def self.up
    create_table :gallery_albums do |t|
      t.string :title
      t.text :content, :limit => 1.megabyte
      t.integer :cover_photo_id

      t.timestamps
    end

    add_index :gallery_albums, :created_at
  end


  def self.down
    drop_table :gallery_albums
  end
end

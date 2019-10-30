class CreateGalleryPhotos < ActiveRecord::Migration
  def self.up
    create_table :gallery_photos do |t|
      t.integer :gallery_album_id

      t.string :photo_file_name
      t.integer :photo_file_size
      t.string :photo_content_type
      t.datetime :photo_updated_at 
    
      t.text :caption
      t.integer :sort

      t.timestamps
    end

    add_index :gallery_photos, :created_at
  end


  def self.down
    drop_table :gallery_photos
  end
end

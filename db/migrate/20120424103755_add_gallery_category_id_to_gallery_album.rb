class AddGalleryCategoryIdToGalleryAlbum < ActiveRecord::Migration
  def change
    add_column :gallery_albums, :gallery_category_id, :integer
    add_index :gallery_albums, :gallery_category_id
  end
end

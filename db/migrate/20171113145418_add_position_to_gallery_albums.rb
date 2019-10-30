class AddPositionToGalleryAlbums < ActiveRecord::Migration
  def change
    add_column :gallery_albums, :position, :integer, :default => 0
    add_index :gallery_albums, :position
  end
end

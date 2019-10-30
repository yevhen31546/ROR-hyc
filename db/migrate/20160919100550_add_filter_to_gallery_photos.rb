class AddFilterToGalleryPhotos < ActiveRecord::Migration
  def change
    add_column :gallery_photos, :filter, :string
  end
end

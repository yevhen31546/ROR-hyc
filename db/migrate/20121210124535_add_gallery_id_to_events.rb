class AddGalleryIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :gallery_album_id, :integer
  end
end

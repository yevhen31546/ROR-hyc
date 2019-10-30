class AddFilterDescriptionsToGalleryAlbums < ActiveRecord::Migration
  def change
    add_column :gallery_albums, :filter_event_desc, :text
    add_column :gallery_albums, :filter_prize_giving_desc, :text
  end
end

class AddParentIdToGalleryCategories < ActiveRecord::Migration
  def change
    add_column :gallery_categories, :parent_id, :integer
    add_index :gallery_categories, :parent_id

    add_column :gallery_categories, :position, :integer
    add_index :gallery_categories, :position
  end
end

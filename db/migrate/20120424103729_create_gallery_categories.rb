class CreateGalleryCategories < ActiveRecord::Migration
  def change
    create_table :gallery_categories do |t|
      t.string :name

      t.timestamps
    end
    add_index :gallery_categories, :name
  end
end

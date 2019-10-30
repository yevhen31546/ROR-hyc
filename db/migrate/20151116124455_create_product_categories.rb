class CreateProductCategories < ActiveRecord::Migration
  def change
    create_table :product_categories do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
    add_index :product_categories, :position
  end
end

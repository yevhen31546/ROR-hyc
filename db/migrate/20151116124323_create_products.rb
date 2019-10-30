class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :product_category_id
      t.string :name
      t.integer :position

      t.timestamps
    end
    add_index :products, :position
  end
end

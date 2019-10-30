class CreateNewsCategories < ActiveRecord::Migration
  def change
    create_table :news_categories do |t|
      t.string :name

      t.timestamps
    end

    add_index :news_categories, :name

    add_column :news_items, :news_category_id, :integer
    add_index :news_items, :news_category_id
  end
end

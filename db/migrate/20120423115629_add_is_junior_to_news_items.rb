class AddIsJuniorToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :is_junior, :boolean
    add_index :news_items, :is_junior
  end
end

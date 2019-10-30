class AddOrderToNewsItems < ActiveRecord::Migration
  def change
    add_column :news_items, :ordering, :integer
  end
end

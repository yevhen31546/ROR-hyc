class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :product_id, :null => false
      t.integer :amount, :null => false
      t.timestamps
    end
  end
end

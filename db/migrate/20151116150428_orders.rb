class Orders < ActiveRecord::Migration
  def up
    # drop_table :orders

  	create_table :orders do |t|
  	  t.integer :id
  	  t.string :member_name, :null => false
  	  t.string :email, :null => false
  	  t.integer :member_id, :null => false
  	  t.integer :payment_item_id, :null => true
  	  t.integer :payment_status, :default => 0
  	  t.string :comment
  	  t.timestamps
  	end
  end

  def down
  end
end

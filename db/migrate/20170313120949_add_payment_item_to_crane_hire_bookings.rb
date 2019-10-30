class AddPaymentItemToCraneHireBookings < ActiveRecord::Migration
  def change
    add_column :crane_hire_bookings, :payment_item_id, :integer
    add_index :crane_hire_bookings, :payment_item_id
  end
end

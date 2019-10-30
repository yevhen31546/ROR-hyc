class AddStatusToCraneHireBookings < ActiveRecord::Migration
  def change
    add_column :crane_hire_bookings, :payment_status, :integer, :default => false
    add_index :crane_hire_bookings, :payment_status
  end
end

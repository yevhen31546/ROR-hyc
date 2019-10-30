class AddFieldsToCraneHireBooking < ActiveRecord::Migration
  def change
    add_column :crane_hire_bookings, :crane_in_out, :string
    add_column :crane_hire_bookings, :crane_op, :string
  end
end

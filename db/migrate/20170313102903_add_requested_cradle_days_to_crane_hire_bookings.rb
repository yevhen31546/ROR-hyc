class AddRequestedCradleDaysToCraneHireBookings < ActiveRecord::Migration
  def change
    add_column :crane_hire_bookings, :requested_cradle_days, :integer
  end
end

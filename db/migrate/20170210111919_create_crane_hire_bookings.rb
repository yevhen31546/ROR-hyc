class CreateCraneHireBookings < ActiveRecord::Migration
  def change
    create_table :crane_hire_bookings do |t|
      t.boolean :is_admin, :null => false, :default => 0
      t.boolean :is_member, :null => false
      t.string :owner_name, :null => false
      t.string :mobile, :null => false
      t.string :email, :null => false
      t.string :boat_name
      t.string :boat_type
      t.string :loa
      t.string :payment_ref
      t.string :crane_size
      t.datetime :crane_hire_start_at, :null => false
      t.datetime :crane_hire_end_at, :null => false
      t.references :crane_hire_price
      t.boolean :requested_cradle
      t.datetime :cradle_start_date
      t.datetime :cradle_end_date
      t.boolean :requested_dry_pad
      t.boolean :mast
      t.boolean :power_washer
      t.boolean :one_design
      t.decimal :total_charge, precision: 10, scale: 2, :null => true
      t.text :comments
      t.timestamps
    end

    add_index :crane_hire_bookings, :is_admin
    add_index :crane_hire_bookings, :owner_name
    add_index :crane_hire_bookings, :email
    add_index :crane_hire_bookings, :cradle_start_date
    add_index :crane_hire_bookings, :cradle_end_date
    add_index :crane_hire_bookings, :crane_hire_start_at
    add_index :crane_hire_bookings, :crane_hire_end_at
    add_index :crane_hire_bookings, :created_at
  end
end

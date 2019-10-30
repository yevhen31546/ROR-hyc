class CreateEventDinnerBookings < ActiveRecord::Migration
  def change
    create_table :event_dinner_bookings do |t|
      t.boolean :is_admin
      t.integer :event_dinner_id
      t.string :name
      t.string :phone
      t.string :email
      t.string :table_name
      t.integer :quantity
      t.decimal :total_charge, precision: 10, scale: 2
      t.integer :payment_item_id
      t.integer :payment_ref
      t.integer :payment_status, :default => false
      t.text :comments

      t.timestamps
    end
    add_index :event_dinner_bookings, :is_admin
    add_index :event_dinner_bookings, :event_dinner_id
    add_index :event_dinner_bookings, :email
    add_index :event_dinner_bookings, :table_name
    add_index :event_dinner_bookings, :created_at
    add_index :event_dinner_bookings, :payment_status
  end
end

class CreateEventDinners < ActiveRecord::Migration
  def change
    create_table :event_dinners do |t|
      t.integer :event_id
      t.date :event_date
      t.decimal :ticket_price, precision: 10, scale: 2
      t.string :table_name_type
      t.text :comments

      t.timestamps
    end
    add_index :event_dinners, :event_id
    add_index :event_dinners, :event_date
  end
end

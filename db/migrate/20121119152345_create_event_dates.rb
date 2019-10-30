class CreateEventDates < ActiveRecord::Migration
  def change
    create_table :event_dates do |t|
      t.integer :event_id
      t.date :date, :null => false
    end
    add_index :event_dates, :event_id
    add_index :event_dates, :date
  end
end

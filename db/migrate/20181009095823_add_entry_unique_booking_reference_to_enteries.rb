class AddEntryUniqueBookingReferenceToEnteries < ActiveRecord::Migration
  def change
    add_column :entries, :entry_unique_booking_reference, :string
    add_index :entries, :entry_unique_booking_reference, :unique => true
  end
end

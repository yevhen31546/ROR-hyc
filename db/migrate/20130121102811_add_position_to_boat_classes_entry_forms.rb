class AddPositionToBoatClassesEntryForms < ActiveRecord::Migration
  def change
    add_column :boat_classes_entry_forms, :position, :integer
    add_index :boat_classes_entry_forms, :position
  end
end

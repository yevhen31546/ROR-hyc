class AddBoatTypeNoteToEntryForms < ActiveRecord::Migration
  def change
    add_column :entry_forms, :display_boat_type_note, :string
    add_column :entry_forms, :additional_note, :text
  end
end

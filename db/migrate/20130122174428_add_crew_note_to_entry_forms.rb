class AddCrewNoteToEntryForms < ActiveRecord::Migration
  def change
    add_column :entry_forms, :crew_note, :string
  end
end

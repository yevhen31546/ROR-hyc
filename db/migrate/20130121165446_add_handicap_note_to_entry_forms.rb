class AddHandicapNoteToEntryForms < ActiveRecord::Migration
  def change
    add_column :entry_forms, :handicap_note, :string
    remove_column :entry_forms, :display_cruisers_note
  end
end

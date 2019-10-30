class AddChargeNoteToEntryForms < ActiveRecord::Migration
  def change
    add_column :entry_forms, :charge_note, :text, :limit => 1.megabyte
  end
end

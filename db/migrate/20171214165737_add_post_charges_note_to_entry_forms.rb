class AddPostChargesNoteToEntryForms < ActiveRecord::Migration
  def change
    add_column :entry_forms, :post_charge_note, :text, :limit => 1.megabyte
  end
end

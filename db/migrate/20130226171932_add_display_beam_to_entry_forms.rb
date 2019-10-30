class AddDisplayBeamToEntryForms < ActiveRecord::Migration
  def change
    add_column :entry_forms, :display_beam, :boolean
  end
end

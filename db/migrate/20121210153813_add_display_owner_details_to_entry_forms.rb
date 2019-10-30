class AddDisplayOwnerDetailsToEntryForms < ActiveRecord::Migration
  def change
    add_column :entry_forms, :display_owner_details, :boolean
  end
end

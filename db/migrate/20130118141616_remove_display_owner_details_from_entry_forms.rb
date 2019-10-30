class RemoveDisplayOwnerDetailsFromEntryForms < ActiveRecord::Migration
  def up
    remove_column :entry_forms, :display_owner_details
  end

  def down
    add_column :entry_forms, :display_owner_details, :boolean
  end
end

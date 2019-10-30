class AddContactDetailsOptions < ActiveRecord::Migration
  def up
    add_column :entry_forms, :display_helm_contact_details, :boolean
    add_column :entry_forms, :display_crew_contact_details, :boolean
  end

  def down
    remove_column :entry_forms, :display_crew_contact_details, :boolean
    remove_column :entry_forms, :display_crew_contact_details, :boolean
  end
end

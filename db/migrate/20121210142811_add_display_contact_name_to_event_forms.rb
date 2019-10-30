class AddDisplayContactNameToEventForms < ActiveRecord::Migration
  def change
    add_column :entry_forms, :display_contact_name, :boolean

  end
end

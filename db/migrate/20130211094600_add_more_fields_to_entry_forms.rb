class AddMoreFieldsToEntryForms < ActiveRecord::Migration
  def change
    remove_column :entry_forms, :display_contact_name
    remove_column :entries, :first_name
    remove_column :entries, :last_name

    create_table :entry_form_categories do |t|
      t.integer :entry_form_id
      t.string :name
      t.text :options
      t.integer :position
      t.timestamps
    end
    add_index :entry_form_categories, :entry_form_id
    add_index :entry_form_categories, :position

    create_table :countries_entry_forms, :id => false do |t|
      t.integer :country_id
      t.integer :entry_form_id
    end

    add_index :countries_entry_forms, :country_id
    add_index :countries_entry_forms, :entry_form_id

    create_table :entries_entry_form_categories do |t|
      t.integer :entry_id
      t.integer :entry_form_category_id
      t.string :value
    end
    add_index :entries_entry_form_categories, :entry_id
    add_index :entries_entry_form_categories, :entry_form_category_id
  end
end

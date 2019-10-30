class AddFieldsToEntryForms < ActiveRecord::Migration
  def change
    add_column :entries, :marina_accommodation_required, :boolean
    add_column :entries, :arrival_date, :datetime

    add_column :entry_forms, :display_marina_accommodation_required, :boolean
    add_column :entry_forms, :display_arrival_date, :boolean

    add_column :entries, :boat_builder_id, :integer
    add_column :entries, :country_id, :integer
    add_column :entries, :fleet_id, :integer

    add_column :entry_forms, :rig_note_1, :string
    add_column :entry_forms, :rig_note_2, :string
    add_column :entry_forms, :fleet_note, :string
    add_column :entry_forms, :display_country, :boolean
    
    create_table :boat_builders do |t|
      t.string :name, :null => false
    end
    add_index :boat_builders, :name, :unique => true

    create_table :countries do |t|
      t.string :name, :null => false
    end
    add_index :countries, :name, :unique => true

    create_table :fleets do |t|
      t.string :name, :null => false
    end
    add_index :fleets, :name, :unique => true

    create_table :entry_forms_fleets, :id => false do |t|
      t.integer :entry_form_id, :null => false
      t.integer :fleet_id, :null => false
    end
    add_index :entry_forms_fleets, :entry_form_id
    add_index :entry_forms_fleets, :fleet_id
  end
end

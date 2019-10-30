class AddFieldsToEntries < ActiveRecord::Migration
  def change
    rename_column :entries, :isa_level, :crew_sailing_level
    add_column :entries, :crew_sailing_level_date, :string

    add_column :entries, :helm_sailing_level, :string
    add_column :entries, :helm_sailing_level_date, :string

    add_column :entries, :boat_class_specific, :string


    rename_column :entry_forms, :display_isa_level, :display_helm_sailing_level
    add_column :entry_forms, :display_helm_sailing_level_date, :boolean

    add_column :entry_forms, :display_crew_sailing_level, :boolean
    add_column :entry_forms, :display_crew_sailing_level_date, :boolean

    add_column :entry_forms, :display_boat_class_specific, :boolean
  end
end

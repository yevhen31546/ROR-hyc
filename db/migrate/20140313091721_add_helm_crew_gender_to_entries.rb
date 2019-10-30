class AddHelmCrewGenderToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :helm_gender, :string
    add_column :entries, :crew_gender, :string

    add_column :entry_forms, :display_helm_gender, :boolean
    add_column :entry_forms, :display_crew_gender, :boolean
  end
end

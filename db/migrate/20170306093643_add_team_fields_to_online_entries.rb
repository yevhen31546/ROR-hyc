class AddTeamFieldsToOnlineEntries < ActiveRecord::Migration
  def change
    add_column :entries, :team, :string
    add_column :entries, :team_captain, :string

    add_column :entry_forms, :display_team, :boolean, :null => true
    add_column :entry_forms, :display_team_captain, :boolean, :null => true
  end
end

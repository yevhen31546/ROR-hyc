class ChangeTrophyEvents < ActiveRecord::Migration
  def up
    remove_column :trophy_events, :columns
    add_column :trophy_events, :boat, :boolean
    add_column :trophy_events, :owner, :boolean
    add_column :trophy_events, :helm, :boolean
    add_column :trophy_events, :crew, :boolean
    add_column :trophy_events, :club, :boolean
  end

  def down
    add_column :trophy_events, :columns, :string
    remove_column :trophy_events, :boat
    remove_column :trophy_events, :owner
    remove_column :trophy_events, :helm
    remove_column :trophy_events, :crew
    remove_column :trophy_events, :club
  end
end

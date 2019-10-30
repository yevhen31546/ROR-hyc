class ModifyTrophyWinners < ActiveRecord::Migration
  def up
    rename_column :trophy_winners, :event_id, :trophy_event_id
    remove_column :trophy_winners, :club_id
    add_column :trophy_winners, :club, :string
    add_column :trophy_winners, :position, :integer
    add_column :trophy_winners, :trophy_comment, :text
    add_column :trophy_winners, :trophy_given_by, :string

    create_table :trophy_events do |t|
      t.string :name
      t.integer :year
      t.string :event_type
      t.text :columns
      t.integer :position
    end

    add_index :trophy_events, :year
    add_index :trophy_events, :event_type
    add_index :trophy_events, :position
  end

  def down
  end
end

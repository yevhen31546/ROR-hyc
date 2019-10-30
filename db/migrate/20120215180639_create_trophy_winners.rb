class CreateTrophyWinners < ActiveRecord::Migration
  def change
    create_table :trophy_winners do |t|
      t.integer :event_id, :null => false
      t.string :trophy, :null => false
      t.string :category
      t.integer :club_id
      t.string :boat
      t.string :owner
      t.string :helm
      t.string :crew

      t.timestamps
    end

    add_index :trophy_winners, :event_id
    add_index :trophy_winners, :trophy
    add_index :trophy_winners, :club_id
    add_index :trophy_winners, :category
    add_index :trophy_winners, :created_at
  end
end

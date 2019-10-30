class CreateRacings < ActiveRecord::Migration
  def change
    create_table :racings do |t|
      t.date :event_date
      t.string :race_officer
      t.string :assistant_race_officer
      t.string :boat_assisting
      t.string :classes_racing
      t.string :open_events_at_hyc

      t.timestamps
    end
  end
end

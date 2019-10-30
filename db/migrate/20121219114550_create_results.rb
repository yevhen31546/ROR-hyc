class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :year
      t.string :event_type
      t.string :event
      t.string :class_name

      t.timestamps
    end
  end
end

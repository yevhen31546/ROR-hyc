class CreateTides < ActiveRecord::Migration
  def change
    create_table :tides do |t|
      t.datetime :tide_at
      t.float :height

      t.timestamps
    end
    add_index :tides, :tide_at
  end
end

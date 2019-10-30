class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :initials

      t.timestamps
    end

    add_index :clubs, :name
    add_index :clubs, :initials
  end
end

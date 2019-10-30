class CreateNavbars < ActiveRecord::Migration
  def self.up
    create_table :navbars do |t|
      t.string :code
      t.string :name

      t.timestamps
    end

    add_index :navbars, :code
    add_index :navbars, :name
  end

  def self.down
    drop_table :navbars
  end
end

class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :key
      t.string :value, :limit => 512
      t.string :label
      t.string :value_type, :default => 'string'

      t.timestamps
    end

    add_index :settings, :key
    add_index :settings, :label
  end

  def self.down
    drop_table :settings
  end
end

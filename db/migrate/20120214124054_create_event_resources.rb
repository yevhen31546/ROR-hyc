class CreateEventResources < ActiveRecord::Migration
  def up
    create_table :event_resources do |t|
      t.integer :event_id
      t.integer :resource_id
      t.timestamps
    end

    add_index :event_resources, :event_id
    add_index :event_resources, :resource_id
  end

  def down
    drop_table :event_resources
  end
end

class CreateRoleResourceAccesses < ActiveRecord::Migration
  def up
    create_table :role_resource_accesses do |t|
      t.integer :object_id
      t.string :object_type
      t.integer :role_id
    end
    add_index :role_resource_accesses, :object_id
    add_index :role_resource_accesses, :object_type
    add_index :role_resource_accesses, :role_id
  end

  def down
    drop_table :role_resource_accesses
  end
end

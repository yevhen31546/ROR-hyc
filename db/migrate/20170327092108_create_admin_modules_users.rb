class CreateAdminModulesUsers < ActiveRecord::Migration
  def up
    create_table :admin_modules_users do |t|
      t.integer :admin_module_id, :null => false
      t.integer :user_id, :null => false
    end
    add_index :admin_modules_users, :user_id
    add_index :admin_modules_users, :admin_module_id
  end

  def down
    drop_table :admin_modules_users
  end
end

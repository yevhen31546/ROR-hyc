class CreateAdminModules < ActiveRecord::Migration
  def self.up
    create_table :admin_modules do |t|
      t.string :name
      t.string :controller
      t.string :action, :default => 'index'
      t.boolean :active, :default => false, :null => false
      t.boolean :superadmin_active, :default => true, :null => false
      t.integer :sort

      t.timestamps
    end

    add_index :admin_modules, :name
    add_index :admin_modules, :active
    add_index :admin_modules, :superadmin_active
  end

  def self.down
    drop_table :admin_modules
  end
end

class AddParentIdToAdminModules < ActiveRecord::Migration
  def change
    add_column :admin_modules, :parent_id, :integer
    add_index :admin_modules, :parent_id

  end
end

class AddIsAdminToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :is_admin, :boolean
    add_index :entries, :is_admin
  end
end

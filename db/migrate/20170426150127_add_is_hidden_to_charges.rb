class AddIsHiddenToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :is_hidden, :boolean
    add_index :charges, :is_hidden
  end
end

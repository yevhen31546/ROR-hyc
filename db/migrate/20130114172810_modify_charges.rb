class ModifyCharges < ActiveRecord::Migration
  def up
    remove_column :charges, :discount_price
    add_column :charges, :group_name, :string
    add_column :charges, :group_code, :string
    add_column :charges, :date, :datetime
    add_column :charges, :position, :integer
    rename_column :charges, :type, :charge_type
  end

  def down
    add_column :charges, :discount_price, :decimal
    remove_column :charges, :group_name
    remove_column :charges, :date
    remove_column :charges, :position
    rename_column :charges, :charge_type, :type
  end
end

class AddAccountNumberToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :account_code, :string
  end
end

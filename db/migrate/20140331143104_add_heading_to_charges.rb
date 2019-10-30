class AddHeadingToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :heading, :string
  end
end

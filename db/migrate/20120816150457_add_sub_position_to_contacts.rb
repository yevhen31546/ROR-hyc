class AddSubPositionToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :sub_position, :string
  end
end

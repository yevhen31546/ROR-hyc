class AddEmailToCommittees < ActiveRecord::Migration
  def change
    add_column :committees, :email, :string
  end
end

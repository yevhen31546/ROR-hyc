class AddOrderToResults < ActiveRecord::Migration
  def change
    add_column :results, :position, :integer
    add_index :results, :position
  end
end

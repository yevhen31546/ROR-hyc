class AddEventPositionToResults < ActiveRecord::Migration
  def change
    add_column :results, :event_position, :integer
    add_index :results, :event_position
  end
end

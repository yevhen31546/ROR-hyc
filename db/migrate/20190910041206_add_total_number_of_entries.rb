class AddTotalNumberOfEntries < ActiveRecord::Migration
  def change
    add_column :events, :total_number_of_entries, :integer
  end

  def down
  end
end

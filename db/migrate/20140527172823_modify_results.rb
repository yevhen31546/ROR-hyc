class ModifyResults < ActiveRecord::Migration
  def up
    add_column :results, :year, :integer
    add_column :results, :event_type, :string
    add_index :results, :year
    add_index :results, :event_type
  end

  def down
    remove_column :results, :year
    remove_column :results, :event_type
  end
end

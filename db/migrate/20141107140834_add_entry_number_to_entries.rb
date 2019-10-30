class AddEntryNumberToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :entry_number, :integer
    add_index :entries, :entry_number
  end
end

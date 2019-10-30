class AddEnteredInResultsToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :entered_in_results, :boolean
  end
end

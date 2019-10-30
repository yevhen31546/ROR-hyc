class AddShowResultsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :show_results, :boolean, :default => false
    add_index :events, :show_results
  end
end

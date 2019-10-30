class ModifyResultsTable < ActiveRecord::Migration
  def up
    add_column :results, :event_id, :integer
    add_column :results, :result_file_name, :string
    add_column :results, :result_content_type, :string
    add_column :results, :result_file_size, :integer
    add_column :results, :result_file_updated_at, :datetime
    remove_column :results, :event
    remove_column :results, :year
    remove_column :results, :event_type
    remove_column :results, :url
  end

  def down
    remove_column :results, :result_file_name
    remove_column :results, :result_content_type
    remove_column :results, :result_file_size
    remove_column :results, :result_file_updated_at
  end
end

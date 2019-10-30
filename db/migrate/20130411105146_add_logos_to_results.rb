class AddLogosToResults < ActiveRecord::Migration
  def change
    add_column :results, :event_logo_file_name, :string
    add_column :results, :event_logo_file_size, :integer
    add_column :results, :event_logo_content_type, :string
    add_column :results, :event_logo_updated_at, :datetime

    add_column :results, :venue_logo_file_name, :string
    add_column :results, :venue_logo_file_size, :integer
    add_column :results, :venue_logo_content_type, :string
    add_column :results, :venue_logo_updated_at, :datetime
  end
end

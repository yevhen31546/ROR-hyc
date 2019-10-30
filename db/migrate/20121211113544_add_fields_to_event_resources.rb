class AddFieldsToEventResources < ActiveRecord::Migration
  def change
    add_column :event_resources, :name, :string
    add_column :event_resources, :resource_type, :string

    add_column :event_resources, :occurrence, :string
    add_index :event_resources, :occurrence

    add_column :event_resources, :comment, :text

    add_column :event_resources, :url, :string

    add_column :event_resources, :url_target, :string

    add_column :event_resources, :position, :integer
    add_index :event_resources, :position

    add_column :event_resources, :resource_file_name, :string
    add_column :event_resources, :resource_file_size, :integer
    add_column :event_resources, :resource_content_type, :string
    add_column :event_resources, :resource_updated_at, :datetime

    remove_column :event_resources, :resource_id
  end
end

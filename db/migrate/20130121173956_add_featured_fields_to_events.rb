class AddFeaturedFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :is_featured, :boolean
    add_index :events, :is_featured

    add_column :events, :featured_logo_file_name, :string

    add_column :events, :featured_logo_content_type, :string

    add_column :events, :featured_logo_file_size, :integer

    add_column :events, :featured_logo_update_at, :datetime

    add_column :events, :featured_position, :integer
    add_index :events, :featured_position

    add_column :events, :featured_url, :string
  end
end

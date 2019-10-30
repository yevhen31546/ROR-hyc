class EventImagesShouldBeIndependentFromAsset < ActiveRecord::Migration
  def change
    remove_column :events, :sponsor_logo_id
    add_column :events, :sponsor_logo_file_name, :string
    add_column :events, :sponsor_logo_content_type, :string
    add_column :events, :sponsor_logo_file_size, :integer
  end
end

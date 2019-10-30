class AddButtonStyleToEventResources < ActiveRecord::Migration
  def change
    add_column :event_resources, :button_style, :string
  end
end

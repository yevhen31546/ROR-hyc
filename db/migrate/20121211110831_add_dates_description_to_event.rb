class AddDatesDescriptionToEvent < ActiveRecord::Migration
  def change
    add_column :events, :dates_description, :text

  end
end

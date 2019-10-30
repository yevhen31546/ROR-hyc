class AddHullColourToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :hull_colour, :string
    add_column :entry_forms, :display_hull_colour, :boolean, :null => true
  end
end

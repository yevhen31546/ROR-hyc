class AddEntryConditionsToEntryForms < ActiveRecord::Migration
  def change
    add_column :entry_forms, :entry_conditions, :text, :limit => 1.megabyte
  end
end

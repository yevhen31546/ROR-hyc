class AddSaturdayOnlyToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :is_saturday_only_lambay, :boolean
    add_column :entry_forms, :display_saturday_only_lambay, :boolean, :default => false
  end
end
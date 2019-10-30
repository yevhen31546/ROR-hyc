class AddIsoraRegisteredToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :is_isora_registered, :boolean
    add_column :entry_forms, :display_isora_registered, :boolean, :default => false
  end
end

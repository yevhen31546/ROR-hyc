class CreateEntryLists < ActiveRecord::Migration
  def change
    create_table :entry_lists do |t|
      t.integer :event_id
      t.string :name
    end
    add_index :entry_lists, :event_id

    create_table :entry_list_columns do |t|
      t.integer :entry_list_id
      t.string :name
      t.string :entry_attr
      t.string :position
    end
    add_index :entry_list_columns, :entry_list_id
    add_index :entry_list_columns, :position
  end
end

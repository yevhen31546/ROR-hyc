class AddDatesToEvents < ActiveRecord::Migration
  def change
    remove_column :events, :closing_date

    add_column :events, :online_entry_show_date, :date
    add_column :events, :online_entry_hide_date, :date
    add_column :events, :entry_list_show_date, :date
    add_column :events, :entry_list_hide_date, :date

    add_index :events, :online_entry_show_date
    add_index :events, :online_entry_hide_date
    add_index :events, :entry_list_show_date
    add_index :events, :entry_list_hide_date
  end
end

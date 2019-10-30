class AddShortOptionsToEntryFormCategories < ActiveRecord::Migration
  def change
    add_column :entry_form_categories, :short_options, :text
  end
end

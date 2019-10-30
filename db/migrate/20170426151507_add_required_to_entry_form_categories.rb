class AddRequiredToEntryFormCategories < ActiveRecord::Migration
  def change
    add_column :entry_form_categories, :is_required, :boolean
  end
end

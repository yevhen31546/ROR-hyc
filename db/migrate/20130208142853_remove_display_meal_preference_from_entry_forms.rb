class RemoveDisplayMealPreferenceFromEntryForms < ActiveRecord::Migration
  def up
    remove_column :entry_forms, :display_meal_preference
    remove_column :entry_forms, :display_category
  end

  def down
  end
end

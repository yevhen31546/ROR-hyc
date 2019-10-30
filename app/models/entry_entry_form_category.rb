class EntryEntryFormCategory < ActiveRecord::Base
  self.table_name = 'entries_entry_form_categories'

  # validations
  validates :entry_form_category_id, :presence => true
  
  # associations
  belongs_to :entry
  belongs_to :entry_form_category
end

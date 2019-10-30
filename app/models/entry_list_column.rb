class EntryListColumn < ActiveRecord::Base
  belongs_to :entry_list
  validates :name, :position, :presence => true
  validates :entry_attr, :uniqueness => {:scope => :entry_list_id}
end
class EntryList < ActiveRecord::Base
  validates :name, :event, :presence => true

  belongs_to :event
  
  has_many :entry_list_columns, :order => 'position asc'
  accepts_nested_attributes_for :entry_list_columns, :allow_destroy => true

  def column_for(attribute)
    entry_list_columns.find { |c| c.entry_attr == attribute.to_s}
  end

  class << self
    def admin
      where(:name => 'Entry List Admin')
    end

    def public_lists
      where(:name => 'Entry List Public')
    end
  end
end
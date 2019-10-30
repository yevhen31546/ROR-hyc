class CustomField < ActiveRecord::Base
  attr_accessible :entry_form_id, :datatype, :name, :is_required, :extra

  belongs_to :entry_form

  DATATYPES = ['string', 'boolean', 'text', 'select']

  validates :name, :datatype, :presence => true
  validates :datatype, :inclusion => DATATYPES

  default_value_for :datatype, DATATYPES.first

  def options
    extra.presence && ([''] + extra.lines.to_a.map(&:strip))
  end
end

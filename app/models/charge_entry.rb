class ChargeEntry < ActiveRecord::Base
  self.table_name = 'charges_entries'

  # validations
  validates :charge_id, :quantity, :presence => true
  validates :quantity, :numericality => {:greater_than_or_equal_to => 0, :only_integer => true}

  # associations
  belongs_to :charge
  belongs_to :entry
end

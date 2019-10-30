class Charge < ActiveRecord::Base

  default_scope :order => 'position asc'

  # enumerations
  TYPES = ['Full Fee', 'Fixed', 'Radio', 'Checkbox', 'Discount', 'Quantity', 'LateFee', 'Text']
  DEFAULT_CHARGE_TYPES = ['Full Fee', 'LateFee', 'Discount', 'Fixed']

  # validations
  validates :charge_type, :name, :presence => true
  validates :price, :numericality => true, :presence => true, :unless => Proc.new { |c| c.charge_type == "Text" }

  # associations
  belongs_to :entry_form
  has_many :charges_entries, :class_name => 'ChargeEntry'
  has_many :entries, :through => :charges_entries, :dependent => :destroy

  default_value_for :position do
    (scoped.maximum(:position) || 0) + 1
  end

  class << self
    def visible
      where(:is_hidden => false)
    end

    def fixed
      where(:charge_type => 'Fixed')
    end

    def full_fees
      where(:charge_type => 'Full Fee')
    end

    # you will get the late fee if the date on the charge has already gone
    def applicable_late_fees
      where(:charge_type => 'LateFee').where("date <= ?", Time.now)
    end

    # you can get the discount if the date on the charge has yet to come
    def applicable_discounts
      where(:charge_type => 'Discount').where("date >= ?", Time.now)
    end

    def default
      if applicable_discounts.present?
        applicable_discounts
      else
        where("(charge_type = 'Full Fee') OR (charge_type = 'LateFee' AND date <= ?)", Time.now).reorder('date asc')
      end
    end

    def optional
      where("charge_type NOT IN (?)", DEFAULT_CHARGE_TYPES)
    end
  end

end

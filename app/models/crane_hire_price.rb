class CraneHirePrice < ActiveRecord::Base
  attr_accessible :code, :charge_period, :member_price, :name, :non_member_price, :product_type, :size

  def price_for_member_type(is_member)
    is_member ? self.member_price : self.non_member_price
  end

  class << self
    def by_product_type(product_type)
      where(product_type: product_type)
    end

    def cranes
      by_product_type('crane')
    end

    def extras
      by_product_type('extras')
    end

    def cradles
      by_product_type('cradle')
    end
  end
end

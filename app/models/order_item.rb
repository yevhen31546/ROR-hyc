class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  # attr_accessible :title, :body

  validates :product_id, :amount, :presence => true
  validates :amount, numericality: {greater_than_or_equal_to: 0}

end

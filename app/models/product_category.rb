class ProductCategory < ActiveRecord::Base
  has_many :products, order: "position asc"
  validates :name, :presence => true
end

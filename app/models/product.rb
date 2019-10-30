class Product < ActiveRecord::Base
  belongs_to :product_category

  validates :name, :product_category_id, :presence => true
end

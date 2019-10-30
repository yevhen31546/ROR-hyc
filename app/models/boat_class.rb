class BoatClass < ActiveRecord::Base
  # validations
  validates :boat_category_id, :name, :presence => true

  # associations
  belongs_to :boat_category
end

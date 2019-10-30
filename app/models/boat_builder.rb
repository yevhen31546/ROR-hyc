class BoatBuilder < ActiveRecord::Base
   # validations
  validates :name, :presence => true
end

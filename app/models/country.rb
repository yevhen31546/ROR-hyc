class Country < ActiveRecord::Base
   # validations
  validates :name, :presence => true
end

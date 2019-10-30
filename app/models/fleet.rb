class Fleet < ActiveRecord::Base
   # validations
  validates :name, :presence => true
end

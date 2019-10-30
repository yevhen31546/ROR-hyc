class BoatCategory < ActiveRecord::Base
   # validations
  validates :name, :presence => true

  # associations
  has_many :boat_classes

  def keelboat?
    name == 'One Design Keelboat'
  end

  def cruiser?
    name == 'Cruiser'
  end

  def dinghy?
    name == 'Dinghy'
  end

end

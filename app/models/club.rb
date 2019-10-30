class Club < ActiveRecord::Base
  validates :name, :initials, :presence => true
end

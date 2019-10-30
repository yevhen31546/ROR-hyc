class CrewMember < ActiveRecord::Base
  # validations
  validates :name, :presence => true

  # associations
  belongs_to :entry
  belongs_to :club
end

class Rig < ActiveRecord::Base
  # validations
  validates :name, :presence => true

  # associations
  has_and_belongs_to_many :entry_forms
end

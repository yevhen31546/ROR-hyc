class BoatClassEntryForm < ActiveRecord::Base
  self.table_name = 'boat_classes_entry_forms'

  default_scope :order => "position asc"

  # validations
  validates :boat_class_id, :presence => true

  # associations
  belongs_to :boat_class
  belongs_to :entry_form

  default_value_for :position do
    (scoped.maximum(:position) || 0) + 1
  end
end

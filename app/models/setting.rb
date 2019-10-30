class Setting < ActiveRecord::Base
  VALUE_TYPES = ['text', 'string']
  validates :key, :label, :value_type, :presence => true
end

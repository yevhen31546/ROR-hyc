class EventDate < ActiveRecord::Base
  belongs_to :event

  validates :date, :uniqueness => {:scope => :event_id}
end

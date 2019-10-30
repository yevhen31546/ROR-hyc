class EventDinner < ActiveRecord::Base
  belongs_to :event
  has_many :bookings, class_name: "EventDinnerBooking"

  validates :event_id, :event_date, :ticket_price, :table_name_type, :presence => true

  def title_with_date
    "#{event.title} (#{self.event_date.strftime("%d %b %Y")})"
  end

  def self.by_year(year)
    year.present? ? where("YEAR(event_date) = ?", year) : scoped
  end

  def self.years
    select('distinct(YEAR(event_date)) as year').map(&:year)
  end
end

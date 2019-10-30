class TrophyEvent < ActiveRecord::Base
  belongs_to :trophy_winner

  validates :name, :year, :event_type, presence: true

  EVENT_TYPES = ['club', 'open']
  COLUMN_TYPES = [:boat, :owner, :helm, :crew, :club]

  def columns
    COLUMN_TYPES.select { |column| self.send(column) }
  end

  class << self
    def by_year(year)
      year.present? ? where(:year => year) : scoped
    end

    def by_event_type(event_type)
      event_type.present? ? where(:event_type => event_type) : scoped
    end

    def years
      select('distinct(year) as year').order('year desc').map(&:year)
    end

    def event_types
      select('distinct(event_type) as event_type').map(&:event_type)
    end
  end
end
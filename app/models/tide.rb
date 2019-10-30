class Tide < ActiveRecord::Base
  validates :tide_at, :presence => true, :uniqueness => true
  validates :height, :presence => true

  class << self
    def next_week
      between(Time.now, Time.now+1.week)
    end

    def between(start, finish)
      where("tide_at >= ? AND tide_at <= ?", start.beginning_of_day, finish.end_of_day).order('tide_at asc')
    end

    def years
      Tide.select('distinct(year(tide_at)) as tide_year').map(&:tide_year)
    end
  end
end

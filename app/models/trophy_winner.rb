class TrophyWinner < ActiveRecord::Base
  validates :trophy_event, :category, :presence => true

  belongs_to :trophy_event

  class << self
    def by_year(year)
      if (year.to_i > 0)
        joins(:trophy_event).where("trophy_events.year" => year)
      else
        scoped
      end
    end

    def by_event_type(type)
      if type.present?
        joins(:trophy_event).where("trophy_events.event_type" => type)
      else
        scoped
      end
    end

    def by_trophy_event(trophy_event)
      if trophy_event
        where(:trophy_event_id => trophy_event)
      else
        scoped
      end
    end

    def by_rankings
      # Problem with select("count(*) as rank") with ORDER BY rank, that's why we use find_by_sql.
      self.find_by_sql(
        "SELECT tr1.owner, tr1.boat, count(*) as rank
        FROM trophy_winners tr1
        GROUP BY tr1.owner, tr1.boat")
    end
  end
end

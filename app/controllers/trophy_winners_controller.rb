class TrophyWinnersController < ApplicationController

  def index
    @years = TrophyEvent.years
    @event_types = TrophyEvent.event_types

    @year = params[:year].presence
    @event_type = params[:event_type].presence
    if @year && @event_type
      @trophy_events = TrophyEvent.by_year(@year).by_event_type(@event_type).order('position asc')
    else
      @trophy_events = []
    end
    if (@trophy_event_id = params[:trophy_event_id]).present?
      @trophy_event = TrophyEvent.find(@trophy_event_id)
      @trophy_winners = TrophyWinner.
        by_year(@year).
        by_event_type(@event_type).
        by_trophy_event(@trophy_event).
        order('position asc').
        page(params[:page]).per(100)
    end
    
  end

  def options
    @year = (params[:year].presence || Date.today.year)
    @event_type = params[:event_type].presence
    @trophy_events = TrophyEvent.by_year(@year).by_event_type(@event_type)
    render :partial => 'admin/trophy_events/options'
  end  

  def rankings
    @rankings = Kaminari.paginate_array(TrophyWinner.by_rankings).page(params[:page]).per(100)
  end
end

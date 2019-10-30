class Admin::TrophyWinnersController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => :index
  end

  new_action do 
    before do
      if params[:trophy_event_id].present?
        @trophy_event = TrophyEvent.find(params[:trophy_event_id])
        object.trophy_event = @trophy_event
      end
    end
  end

  create do
    wants.html do
      redirect_to :action => :index, :trophy_event_id => object.trophy_event.id, :event_type => object.trophy_event.event_type, :year => object.trophy_event.year
    end
  end

  update do
    wants.html do
      redirect_to :action => :index, :trophy_event_id => object.trophy_event.id, :event_type => object.trophy_event.event_type, :year => object.trophy_event.year
    end
  end

  def destroy
    @trophy_winner = TrophyWinner.find(params[:id])
    @trophy_event = @trophy_winner.trophy_event
    @trophy_winner.destroy
    redirect_to :action => :index, :trophy_event_id => @trophy_event.id, :event_type => @trophy_event.event_type, :year => @trophy_event.year
  end

  def duplicate
    @trophy_event_id = params[:trophy_event_id]
    @trophy_event = TrophyEvent.find(@trophy_event_id)
    
    if params[:to_trophy_event_id].present?
      @to_trophy_event_id = params[:to_trophy_event_id]
      @to_trophy_event = TrophyEvent.find(@to_trophy_event_id)

      TrophyWinner.by_trophy_event(@trophy_event).to_a.map(&:dup).each do |te| 
        te.trophy_event = @to_trophy_event; 
        TrophyEvent::COLUMN_TYPES.each do |column|
          te.send("#{column}=", nil)
        end
        te.save! 
      end

      redirect_to action: :index, trophy_event_id: @to_trophy_event
    end
  end

  def update_all
    if params[:trophy_winners].present?
      params[:trophy_winners].each do |trophy_winner_id, updates|
        @trophy_winner = TrophyWinner.find(trophy_winner_id)
        @trophy_winner.update_attributes(updates)
      end
      redirect_to :action => :index, :trophy_event_id => @trophy_winner.trophy_event
    else
      redirect_back_or_default :action => :index
    end
  end

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
      @trophy_winners = end_of_association_chain.by_year(@year).
        by_event_type(@event_type).
        by_trophy_event(@trophy_event).
        order('position asc').
        page(params[:page])
    end
  end
end

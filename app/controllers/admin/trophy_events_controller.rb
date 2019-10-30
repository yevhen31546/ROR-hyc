class Admin::TrophyEventsController < Admin::BaseController
  resource_controller

  new_action do 
    before do
      object.year = params[:year]
    end
  end

  def show
    redirect_to :action => :index
  end

  def options
    @year = (params[:year].presence || Date.today.year)
    @event_type = params[:event_type].presence
    @trophy_events = TrophyEvent.by_year(@year).by_event_type(@event_type).order('position asc')
    render :partial => 'admin/trophy_events/options'
  end  

  def duplicate
    @year = params[:year]

    if params[:to_year].present?
      @to_year = params[:to_year]

      @new_trophy_events = TrophyEvent.by_year(@year).to_a.map(&:dup).each { |te| te.year = @to_year; te.save! }

      redirect_to action: :index, year: @to_year
    end
  end

  def update_all
    if params[:trophy_events].present?
      year = nil
      params[:trophy_events].each do |trophy_event_id, updates|
        @trophy_event = TrophyEvent.find(trophy_event_id)
        @trophy_event.update_attributes(updates)

        year = @trophy_event.year
      end
      redirect_to :action => :index, :year => year
    else
      redirect_back_or_default :action => :index
    end
  end

  private
  def collection
    @year = (params[:year].presence || TrophyEvent.years.first)
    end_of_association_chain.by_year(@year).order('position asc').page(params[:page])
  end
end 

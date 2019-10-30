class Admin::EventDinnersController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => :index
  end

  new_action do
    before do
      before_form
    end
  end

  def create
    @event_dinner = EventDinner.new(params[:event_dinner])

    if @event_dinner.save
      redirect_to :action => :index
    else
      before_form
      render :action => :new
    end
  end

  edit do
    before do
      before_form
    end
  end

  def update
    @event_dinner = EventDinner.find(params[:id])

    @event_dinner.assign_attributes(params[:event_dinner])
    if @event_dinner.save
      flash[:success] = "Event dinner updated successfully"
      redirect_back_or_default :action => :edit, :id => @event_dinner.id
    else
      render :action => :edit
    end
  end

  def index
    @year = Date.today.year
    @event_dinners = EventDinner.where("event_date > ?", @year).order("event_date asc")
  end

  def options
    @year = (params[:year].presence || Date.today.year)
    event_dinners = EventDinner.by_year(@year)
    render :partial => 'admin/event_dinners/options', :locals => {:event_dinners => event_dinners, :selected_event_dinner => nil}
  end

  private
  def before_form
    @events = Event.upcoming
  end

  def collection
    @collection = end_of_association_chain.page(params[:page])
  end
end

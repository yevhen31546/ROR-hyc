class Admin::EventDinnerBookingsController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => :index
  end

  new_action do
    before do
      @event_dinner = EventDinner.find(params[:event_dinner_id] || params[:event_dinner_booking].try(:[], :event_dinner_id))
      @event_dinner_booking = @event_dinner.bookings.build(params[:event_dinner_booking])
      @event_dinner_booking.quantity = 1
    end
  end

  def create
    @event_dinner_booking = EventDinnerBooking.new(params[:event_dinner_booking])
    @event_dinner_booking.is_admin = true

    if @event_dinner_booking.save
      redirect_to :action => :index, :event_dinner_id => @event_dinner_booking.event_dinner_id
    else
      render :action => :new
    end
  end

  edit do
  end

  def update
    @event_dinner_booking = EventDinnerBooking.find(params[:id])

    @event_dinner_booking.assign_attributes(params[:event_dinner_booking])
    if @event_dinner_booking.save
      flash[:success] = "Event dinner booking updated successfully"
      redirect_back_or_default :action => :edit, :id => @event_dinner_booking.id
    else
      render :action => :edit
    end
  end

  def index
    @year = (params[:year].presence || (EventDinner.years.include?(Date.today.year) && Date.today.year) || EventDinner.years.first)

    @event_dinners = EventDinner.by_year(@year)

    if params[:event_dinner_id].present?
      @selected_event_dinner = EventDinner.find(params[:event_dinner_id])
      @bookings = @selected_event_dinner.bookings
    end
  end
end

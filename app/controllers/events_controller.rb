#Codereview
class EventsController < ApplicationController

  def index
    @event_type = (params[:event_type].presence || 'open')
    @year = (params[:year].presence || Date.today.year)
    @events = Event.by_year(@year).by_event_type(@event_type).order('date asc')
    
    # capacity management
    if @events.present?
      @normal_number_of_entries = []
      # index = 0
      @events.each do |event|
        # index = index + 1
        @temp_event = Event.find(event.id)
        if @temp_event.entry_form
          @entries = @temp_event.entries.includes(:boat_class, :club, :fleet)
          @entries = @entries.paid

          if @temp_event.total_number_of_entries.present?
            if @entries.count >= @temp_event.total_number_of_entries
              @normal_number_of_entries.push(true)
              # @normal_number_of_entries[index].push(true)
              # event.insert('asdf')
            else
              @normal_number_of_entries.push(false)
            end
          end

        end
      end
    end

  end

  def show
    @event = Event.find(params[:id])
  end

  def options
    @year = (params[:year].presence || Date.today.year)
    @event_type = params[:event_type].presence
    @events = Event.by_year(@year).by_event_type(@event_type)
    @events = @events.show_results if params[:show_results].present?
    render :partial => 'admin/events/options', :locals => {:events => @events}
  end

  def three_d_secure_payment_test
    @payment_item = PaymentItem.new
  end

  def calendar_ajax
    render :layout => false
  end

end

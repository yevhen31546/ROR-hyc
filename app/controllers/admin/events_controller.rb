#Codereview

class Admin::EventsController < Admin::BaseController
  resource_controller

  def new
    @event_type ||= (params[:event_type] || 'open')
    @event = Event.new(:event_type => @event_type)
  end

  def show
    redirect_to :action => 'index'
  end

  def open
    @event_type = 'open'
    collection
    render :index
  end

  def club
    @event_type = 'club'
    collection
    render :index
  end

  def train
    @event_type = 'training'
    collection
    render :index
  end

  def create
    if params[:event].present? && params[:event][:event_logo_attributes].present?
      params[:event][:event_logos_attributes].each do |key, ff|
        if ff[:image].blank?
          params[:event][:event_logos_attributes].delete(key)
        end
      end
    end

    @event = Event.new(params[:event])
    @event_type = @event.event_type

    # puts "#{@event}"
    # render :text => @event.total_number_of_entries
    # Rails.log.debug "Debug Name: #{@event}" #{@event.event_type}

    if @event.save
      # render :text => @event.save
      if @event_type == "training"
        # redirect_to :action => @event_type
        redirect_to :action => '/train'
      else
        redirect_to :action => @event_type
      end
    else
      render :new
    end
  end

  def update
    # render :text => object_params
    load_object
    before :update
    if object.update_attributes object_params
      after :update
      set_flash :update
      # redirect_to :action => @event_type
      if object_params['event_type'] == "training"
        redirect_to :action => 'train'
      else
        # render :text => "open"
        redirect_to :action => @event_type
      end
    else
      after :update_fails
      set_flash :update_fails
      response_for :update_fails
    end
  end

  def destroy
    # render :text => params[:id].split("-")[0].inspect
    @event = Event.find(params[:id].split("-")[0])
    @event_type = @event.event_type
    # render :text => @event.event_type

    @event.destroy
    if @event_type == "training"
      redirect_to :action => 'train'
    else
      redirect_to :action => @event_type
    end

    # redirect_to object_path
  end

  def new_resource
    i = params[:i] || 0
    resource_ids = params[:resource_ids]
    @target_i = i.to_i

    @event = Event.new
    @target_i.times { @event.resources.build }
    @event.resources << Resource.find(resource_ids)
    render :layout => false
  end

  def new_date
    @target_i = (params[:i] || 0).to_i
    @event = Event.new
    (@target_i+1).times { @event.event_dates.build }
    render :layout => false
  end

  def new_event_logo
    @target_i = (params[:i] || 0).to_i
    @event = Event.new
    (@target_i+1).times { @event.event_logos.build }
    render :layout => false
  end

  def options
    @year = (params[:year].presence || Date.today.year)
    @event_type = params[:event_type].presence
    @events = Event.by_year(@year).by_event_type(@event_type)
    if params[:with_forms].present?
      entry_form_sql = (params[:with_forms] == 'true' ? "entry_forms.id IS NOT NULL" : "entry_forms.id IS NULL")
      @events = @events.includes(:entry_form).where(entry_form_sql)
    end
    render :partial => 'admin/events/options', :locals => {:events => @events}
  end

  private
  def collection
    @year = (params[:year].presence || Date.today.year)
    @collection = end_of_association_chain.by_year(@year).order('date asc')
    if (@event_type)
      @collection = @collection.by_event_type(@event_type)
    end
    @events = @collection
    
    #codereview capacity management
    if @events.present?
      @normal_number_of_entries = []
      @events.each do |event|
        @temp_event = Event.find(event.id)
        if @temp_event.entry_form
          @entries = @temp_event.entries.includes(:boat_class, :club, :fleet)
          @entries = @entries.paid

          if @temp_event.total_number_of_entries.present?
            if @entries.count >= @temp_event.total_number_of_entries
              @normal_number_of_entries.push(true)
            else
              @normal_number_of_entries.push(false)
            end
          end

        end
      end
    end

  end
end

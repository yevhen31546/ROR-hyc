class Admin::EventResourcesController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  index.before do
    @event = Event.find(params[:event_id])
    @event_resource = EventResource.new(:event_id => @event.id)
  end


  def create
    @object = @event_resource = EventResource.new(params[:event_resource])
    @event = @event_resource.event
    if @event_resource.save
      redirect_to admin_event_event_resources_path(:event_id => @event)
    else
      render :action => :index
    end    
  end

  update do
    wants.html {
      redirect_to admin_event_event_resources_path(:event_id => object.event)
    }
  end

  destroy do
    wants.html {
      redirect_to admin_event_event_resources_path(:event_id => object.event)
    }
  end

  def update_positions
    begin
      ids = params[:ids]
      raise "ids is nil" unless ids
      ids.each_with_index do |id, index|
        EventResource.find(id).update_attribute(:position, index)
      end
      head :ok
    rescue 
      Rails.logger.error $!
      Rails.logger.error $!.backtrace
      head :bad_request
    end
  end

private
  def collection
    end_of_association_chain.page(params[:page])
  end

end

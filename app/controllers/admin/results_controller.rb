class Admin::ResultsController < Admin::BaseController
  resource_controller

  # by default we just the results GROUPED BY EVENT TITLE
  # if we filter by a particular event title, then we get the results for just that event title
  # this is a very denormalised way of doing things
  def index
    @year = params[:year].presence
    @event_type ||= params[:event_type]
    if @event_type.present? && @year.present?
      if (@event_title = params[:event_title]).present?
        @results = Result.where(:event_type => @event_type, :year => @year)
        @results = @results.where(:event_title => @event_title) if @event_title.present?
      else
        @event_ordering = true
        @results = Result.where(:event_type => @event_type, :year => @year).group('event_title').order_by_event_position
      end
    end
    render 'admin/results/index'
  end

  def open
    @event_type = 'open'
    index
  end

  def club
    @event_type = 'club'
    index
  end

  new_action do
    before do
      object.event_type = params[:event_type]
      object.year = params[:year]
      object.event_title = params[:event_title]
    end
  end

  create do
    wants.html do
      redirect_to :action => :index, :event_type => object.event_type, :year => object.year
    end
  end

  update do
    wants.html do
      redirect_to :action => :index, :event_type => object.event_type, :year => object.year
    end
  end

  destroy do
    wants.html do
      redirect_to :action => :index, :event_type => object.event_type, :year => object.year
    end
  end

  # we need to update the result in a particular way because some updates apply to results with a particular id
  # and some apply to results with a particular event title
  def update_all
    if params[:result_event_titles].present?
      params[:result_event_titles].each do |old_event_title, updates|
        Result.where(
          event_type: params[:event_type],
          event_title: old_event_title,
          year: params[:year]
        ).update_all(updates)
      end
    end
    if params[:result_positions].present?
      params[:result_positions].each do |result_id, updates|
        @result = Result.find(result_id)
        @result.update_attributes(updates)
      end
    end
    redirect_to :action => :index, :year => params[:year], :event_type => params[:event_type], :event_title => params[:event_title]
  end

  def delete_by_event_title
    if params[:id].present?
      result = Result.find(params[:id])
      event_title = result.event_title
      Result.where(year: params[:year], event_type: params[:event_type], event_title: event_title).destroy_all
    end
    redirect_to :action => :index, year: params[:year], event_type: params[:event_type]
  end

  def show
    redirect_to :action => :index
  end
end

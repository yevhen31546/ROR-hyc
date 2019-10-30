class Admin::EntriesController < Admin::BaseController
  resource_controller
  skip_before_filter :require_user, :only => :new_crew_member
  include ChargesHelper

  def show
    redirect_to :action => :index
  end

  new_action do    
    before do
      if params[:event_id].present?
        @event = Event.find(params[:event_id])
        
        # if @event.entry_lists.admin.first.entry_list_columns.count == @event.total_number_of_entries
        #   redirect_to request.referer, :alert => "Training Event Full"
        #   flash[:notice] = "Training Event Full"
        # end

        object.entry_form = @event.entry_form
      end
      object.set_charges(false)
    end
  end

  def create
    preprocess_charges_params
    @entry = Entry.new(params[:entry])
    @entry.is_admin = true # mark this entry as having being created by the admin
    @entry.payment_status = 'paid' # mark this entry as having being created by the admin
    @entry.set_charges(false)
    @entry.generate_booking_reference
    if @entry.save
      @entry.set_entry_number!
      redirect_to :action => :index, :event_id => @entry.event.id
    else
      render :action => :new
    end
  end

  edit do
    before do
      object.terms_agreed = true
      object.set_charges(false)
    end
  end

  def update
    @entry = Entry.find(params[:id])

    @entry = preprocess_charges_params_updates(@entry)

    @entry.assign_attributes(params[:entry])
    @entry.set_charges(false)
    if @entry.save
      flash[:success] = "Entry updated successfully"
      redirect_back_or_default :action => :edit, :id => @entry.id
    else
      render :action => :edit
    end
  end

  def index
    @year = (params[:year].presence || Date.today.year)
    @events = Event.by_year(@year).order('title')
    if params[:event_id].present? && (@selected_event = Event.find(params[:event_id]))
      @selected_entry_list = @selected_event.entry_lists.admin.first
      
      if @selected_entry_list
        @entries = Entry
        @entries = @entries.by_event(@selected_event) if @selected_event.present?
        @entries = @entries.paid.page(params[:page]).per(params[:per] || 100)
        
    #   We don't care here there are too many people in the admin view. Admins can overfill a class if they want to.
      end
    else
      @entry_lists = []
    end
    @filter_options = params[:filter] || {}
  end

  def new_crew_member
    i = params[:i] || 0
    @target_i = i.to_i+1
    @entry = Entry.new(:entry_form_id => params[:entry_form_id])
    @target_i.times { @entry.crew_members.build }
    render :layout => false
  end

  def multiple
    multiple_action = params[:multiple_action].presence || params[:commit]
    entries = Entry.where(:id => params[:ids])
    if entries.present?
      case multiple_action
      when /Enter/
        entry_form = entries.first.entry_form
        entry_form.entries.update_all(:entered_in_results => false)
        entries.update_all(:entered_in_results => true)
      when "Delete"
        entries.destroy_all
      end
    end
    redirect_back_or_default admin_entries_path
  end

  private
  def collection
    @collection = end_of_association_chain.page(params[:page])
  end
end

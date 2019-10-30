class Admin::EntryFormsController < Admin::BaseController
  def index
    @year = (params[:year].presence || Date.today.year)
    @events = Event.by_year(@year).order('date asc').page(params[:page]).per(params[:per] || 300)
  end

  def show
    redirect_to :action => :index
  end

  def edit
    @entry_form = EntryForm.find(params[:id])
  end

  def create
    if params[:entry_form].present? && params[:entry_form][:charges_attributes].present?
      params[:entry_form][:charges_attributes].each do |key, ff|
        if ff[:name].blank?
          params[:entry_form][:charges_attributes].delete(key)
        end
      end
    end
    @entry_form = EntryForm.new
    @entry_form.assign_attributes(params[:entry_form])
    if @entry_form.save
      redirect_to url_for(:action => :index)
    else
      render :action => :new
    end
  end

  def duplicate
    @year = (params[:year].presence || Date.today.year)
    @entry_form = EntryForm.find(params[:id])

    if request.post? && (event_id = params[:event_id]).present?
      dup_entry_form = @entry_form.duplicate(event_id, true)
      flash[:success] = "Entry Form for '#{dup_entry_form.event.title}' created"
      redirect_to admin_entry_forms_path
    else
      @assigned_event_ids = EntryForm.select('distinct(event_id) as event_id').map(&:event_id)
      @events = Event.
        by_year(@year).
        where("id NOT IN (?)", [@assigned_event_ids, @entry_form.event_id].flatten.compact).
        order('created_at desc')
    end
  end

  def new
    @entry_form = EntryForm.new
    @entry_form.event_id = params[:event_id] if params[:event_id].present?
  end

  def update
    @entry_form = EntryForm.find(params[:id])
    # remove charges that have blank names
    if params[:entry_form] && params[:entry_form][:charges_attributes].present?
      params[:entry_form][:charges_attributes].each do |key, ff|
        if ff[:name].blank?
          params[:entry_form][:charges_attributes].delete(key)
        end
      end
    end

    # remove categories that have blank names
    if params[:entry_form] && params[:entry_form][:categories_attributes].present?
      params[:entry_form][:categories_attributes].each do |key, ff|
        if ff[:name].blank?
          params[:entry_form][:categories_attributes].delete(key)
        end
      end
    end

    ## remove boat class positions for classes that have been deselected
    if params[:entry_form] && params[:entry_form][:boat_classes_entry_forms_attributes].present?
      params[:entry_form][:boat_classes_entry_forms_attributes].each do |key, ff|
        begin
          boat_class = BoatClassEntryForm.find(ff[:id]).boat_class
        rescue ActiveRecord::RecordNotFound
          boat_class = nil
        end
        unless params[:entry_form][:boat_class_ids].include?(boat_class.try(:id).to_s)
          params[:entry_form][:boat_classes_entry_forms_attributes].delete(key)
        end
      end
    end

    if @entry_form.update_attributes(params[:entry_form])
      redirect_to edit_admin_entry_form_path(@entry_form), :success => "Entry form updated"
    else
      render :action => :edit
    end
  end

  def destroy
    @entry_form = EntryForm.find(params[:id])
    @year = @entry_form.event.date.year
    @entry_form.destroy
    redirect_to :action => :index, :year => @year
  end

  def new_charge
    i = params[:i] || 0
    @target_i = i.to_i+1
    @entry_form = EntryForm.new
    @target_i.times { @entry_form.charges.build }
    render :layout => false
  end

  def new_category
    i = params[:i] || 0
    @target_i = i.to_i+1
    @entry_form = EntryForm.new
    @target_i.times { @entry_form.categories.build }
    render :layout => false
  end

  def update_charge_positions
    begin
      ids = params[:ids]
      raise "ids is nil" unless ids
      ids.each_with_index do |id, index|
        if id != 'NaN'
          Charge.find(id).update_attribute(:position, index)
        end
      end
      head :ok
    rescue
      Rails.logger.error $!
      Rails.logger.error $!.backtrace
      head :bad_request
    end
  end

  def update_category_positions
    begin
      ids = params[:ids]
      raise "ids is nil" unless ids
      ids.each_with_index do |id, index|
        if id != 'NaN'
          EntryFormCategory.find(id).update_attribute(:position, index)
        end
      end
      head :ok
    rescue
      Rails.logger.error $!
      Rails.logger.error $!.backtrace
      head :bad_request
    end
  end

end

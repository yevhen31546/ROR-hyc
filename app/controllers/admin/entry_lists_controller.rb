class Admin::EntryListsController < Admin::BaseController
  helper_method :entry_list_default_columns
  include Admin::EntryOrderingHelper

  def new
    if params[:event_id].present?
      @event = Event.find(params[:event_id])
    end
    @entry_list = EntryList.new(:event => @event)
  end

  def edit
    @entry_list = EntryList.find(params[:id])
    @event = @entry_list.event
  end

  def update
    @entry_list = EntryList.find(params[:id])

    if params[:entry_list] && params[:entry_list][:entry_list_columns_attributes].present?
      params[:entry_list][:entry_list_columns_attributes].reject! do |column_hsh|
        column_hsh[:position].blank?
      end

      params[:entry_list][:entry_list_columns_attributes].each_with_index do |arr, i|
        params[:entry_list][:entry_list_columns_attributes][i].delete(:id)
      end
    end

    @entry_list.entry_list_columns.destroy_all
    @entry_list.assign_attributes(params[:entry_list])
    @event = @entry_list.event
    if @entry_list.save
      redirect_to edit_admin_entry_list_path(@entry_list)
    else
      render :action => :edit
    end
  end

  def create
    if params[:entry_list] && params[:entry_list][:entry_list_columns_attributes].present?
      params[:entry_list][:entry_list_columns_attributes].reject! do |column_hsh|
        column_hsh[:position].blank?
      end

      params[:entry_list][:entry_list_columns_attributes].each_with_index do |arr, i|
        params[:entry_list][:entry_list_columns_attributes][i].delete("id")
      end
    end

    @entry_list = EntryList.new(params[:entry_list])
    @event = @entry_list.event
    if @entry_list.save
      redirect_to edit_admin_entry_list_path(@entry_list)
    else
      render :action => :new
    end
  end

  def destroy
    @entry_list = EntryList.find(params[:id])
    @entry_list.destroy

    redirect_back_or_default admin_entry_list_path
  end

  def index
    if params[:event_id].present?
      @selected_event = Event.find(params[:event_id])
    end
    @year = params[:year].presence.try(:to_i) || @selected_event.try(:date).try(:year) || Date.today.year
    @events = Event.by_year(@year).order('title')
    if @selected_event
      @entry_lists = @selected_event.entry_lists
    end
  end

  def show
    if params[:id].present?
      @entry_list = @selected_entry_list = EntryList.find(params[:id])
    end

    @selected_event = @selected_entry_list.event

    @filter_options = params[:filter] || {}
    @entries = Entry
    @entries = @entries.by_status(@filter_options[:status]) if @filter_options.present? && @filter_options[:status].present?
    @entries = @entries.by_event(@selected_event) if @selected_event.present?

    @entries = @entries.includes(:boat_class)

    if @entry_list.name =~ /Entry List Admin - Results/i
      @is_results_list = true
    end
    @order, @order_dir = get_admin_entry_ordering()

    if @order
      @entries = @entries.order("#{@order} #{@order_dir}")
    end

    @entries = @entries.paid.page(params[:page])
  end

  def options_for_event
    @event = Event.find(params[:event_id])
    @entry_lists = @event.entry_lists
    render :partial => 'admin/entry_lists/options_for_event', :locals => {:entry_lists => @entry_lists}
  end

  private
  def entry_list_default_columns
    if params[:event_id].present?
      @event = Event.find(params[:event_id])
    else
      @entry_list = EntryList.find(params[:id])
      @event = @entry_list.event
    end
    
    if @event.event_type == "training"
      @entry_list_default_columns ||= [
        [:loan_boat, "Loan Boat"],
        [:sail_number_prefix, "Sail Prefix"],
        [:sail_number, "Sail No"],
        [:sail_number_suffix, "Sail Suffix"],
        [:boat_class, "Boat Class"],
        [:boat_name, "Boat Name"],
        [:owner_name, "Student Name"],
        [:address_line_1, "Address Line 1"],
        [:address_line_2, "Address Line 2"],
        [:address_line_3, "Address Line 3"],
        [:address_line_4, "Address Line 4"],
        [:team, "Team Name"],
        [:team_captain, "Team Captain"],
        [:builder, "Boat Builder"],
        [:model, "Boat Model"],
        [:loa, "LOA"],
        [:lwl, "LWL"],
        [:beam, "Beam"],
        [:hull_colour, "Hull Colour"],
        [:phone, "phone"],
        [:email, "Email"],
        [:club_name, "Club"],
        [:club_initials, "Club Initials"],
        [:has_irc_cert_number, "Has IRC Cert?"],
        [:irc_cert_number, "IRC Cert"],
        [:has_echo_cert_number, "Has ECHO Cert?"],
        [:is_isora_registered, "Is ISORA Registered?"],
        [:is_saturday_only_lambay, "Is Saturday only (Lambay)?"],
        [:helm_name, "Helm Name"],
        [:helm_address_line_1, "Helm Address Line 1"],
        [:helm_address_line_2, "Helm Address Line 2"],
        [:helm_address_line_3, "Helm Address Line 3"],
        [:helm_address_line_4, "Helm Address Line 4"],
        [:helm_phone, "Helm Phone"],
        [:helm_email, "Helm Email"],
        [:helm_dob, "Helm DOB"],
        [:helm_gender, "Helm Gender"],
        [:helm_club, "Helm Club"],
        [:helm_club_initials, "Helm Club Initials"],
        [:crew_name, "Crew Name"],
        [:crew_address_line_1, "Crew Address Line 1"],
        [:crew_address_line_2, "Crew Address Line 2"],
        [:crew_address_line_3, "Crew Address Line 3"],
        [:crew_address_line_4, "Crew Address Line 4"],
        [:crew_phone, "Crew Phone"],
        [:crew_email, "Crew Email"],
        [:crew_dob, "Crew DOB"],
        [:crew_gender, "Crew Gender"],
        [:crew_club, "Crew Club"],
        [:crew_club_initials, "Crew Club Initials"],
        [:fleet, "Fleet"],
        [:rig, "Rig"],
        [:country, "Country"],
        [:guardian, "Guardian"],
        [:guardian_mobile, "Guardian Mobile"],
        [:helm_guardian, "Helm Guardian"],
        [:helm_guardian_mobile, "Helm Guardian Mobile"],
        [:crew_guardian, "Crew Guardian"],
        [:crew_guardian_mobile, "Crew Guardian Mobile"],
        [:non_spinnaker_class, "Non Spinny"],
        [:marina_accommodation_required, "Marina Acc"],
        [:arrival_date, "Marina Date"],
        [:additional_comment, "Notes"],
        [:is_admin, "A"],
        [:payment_id, "Payment Ref"],
        [:created_at, "Entry Date"],
        [:total, "Total"]
      ]
    else
      @entry_list_default_columns ||= [
        [:loan_boat, "Loan Boat"],
        [:sail_number_prefix, "Sail Prefix"],
        [:sail_number, "Sail No"],
        [:sail_number_suffix, "Sail Suffix"],
        [:boat_class, "Boat Class"],
        [:boat_name, "Boat Name"],
        [:owner_name, "Owner Name"],
        [:address_line_1, "Address Line 1"],
        [:address_line_2, "Address Line 2"],
        [:address_line_3, "Address Line 3"],
        [:address_line_4, "Address Line 4"],
        [:team, "Team Name"],
        [:team_captain, "Team Captain"],
        [:builder, "Boat Builder"],
        [:model, "Boat Model"],
        [:loa, "LOA"],
        [:lwl, "LWL"],
        [:beam, "Beam"],
        [:hull_colour, "Hull Colour"],
        [:phone, "phone"],
        [:email, "Email"],
        [:club_name, "Club"],
        [:club_initials, "Club Initials"],
        [:has_irc_cert_number, "Has IRC Cert?"],
        [:irc_cert_number, "IRC Cert"],
        [:has_echo_cert_number, "Has ECHO Cert?"],
        [:is_isora_registered, "Is ISORA Registered?"],
        [:is_saturday_only_lambay, "Is Saturday only (Lambay)?"],
        [:helm_name, "Helm Name"],
        [:helm_address_line_1, "Helm Address Line 1"],
        [:helm_address_line_2, "Helm Address Line 2"],
        [:helm_address_line_3, "Helm Address Line 3"],
        [:helm_address_line_4, "Helm Address Line 4"],
        [:helm_phone, "Helm Phone"],
        [:helm_email, "Helm Email"],
        [:helm_dob, "Helm DOB"],
        [:helm_gender, "Helm Gender"],
        [:helm_club, "Helm Club"],
        [:helm_club_initials, "Helm Club Initials"],
        [:crew_name, "Crew Name"],
        [:crew_address_line_1, "Crew Address Line 1"],
        [:crew_address_line_2, "Crew Address Line 2"],
        [:crew_address_line_3, "Crew Address Line 3"],
        [:crew_address_line_4, "Crew Address Line 4"],
        [:crew_phone, "Crew Phone"],
        [:crew_email, "Crew Email"],
        [:crew_dob, "Crew DOB"],
        [:crew_gender, "Crew Gender"],
        [:crew_club, "Crew Club"],
        [:crew_club_initials, "Crew Club Initials"],
        [:fleet, "Fleet"],
        [:rig, "Rig"],
        [:country, "Country"],
        [:guardian, "Guardian"],
        [:guardian_mobile, "Guardian Mobile"],
        [:helm_guardian, "Helm Guardian"],
        [:helm_guardian_mobile, "Helm Guardian Mobile"],
        [:crew_guardian, "Crew Guardian"],
        [:crew_guardian_mobile, "Crew Guardian Mobile"],
        [:non_spinnaker_class, "Non Spinny"],
        [:marina_accommodation_required, "Marina Acc"],
        [:arrival_date, "Marina Date"],
        [:additional_comment, "Notes"],
        [:is_admin, "A"],
        [:payment_id, "Payment Ref"],
        [:created_at, "Entry Date"],
        [:total, "Total"]
      ]
    end 
  end
end

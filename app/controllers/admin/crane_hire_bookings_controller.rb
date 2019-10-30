class Admin::CraneHireBookingsController < Admin::BaseController
  include ActionView::Helpers::NumberHelper
  include CraneHireBookingHelper
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  new_action.before do
    setup_form_data()
  end

  index.before do
    @crane_hire_booking = CraneHireBooking.new()
    @crane_hire_bookings = @crane_hire_bookings.upcoming
  end

  edit.before do
    setup_form_data()
    @default_time_slots = CraneHireBooking.default_time_slots
    @booked_time_slots = CraneHireBooking.booked_time_slots(object.crane_size, object.crane_hire_primary_start_at_date)

    @crane_hire_booking.crane_hire_primary_start_at_date = @crane_hire_booking.crane_hire_primary_start_at.to_date
    @crane_hire_booking.crane_hire_primary_start_at_time = @crane_hire_booking.crane_hire_primary_start_at.try(:strftime, "%H:%M")
  end

  def create
    setup_form_data()
    @object = @crane_hire_booking = CraneHireBooking.new(params[:crane_hire_booking])
    @default_time_slots = CraneHireBooking.default_time_slots
    @booked_time_slots = CraneHireBooking.booked_time_slots(@crane_hire_booking.crane_size, @crane_hire_booking.crane_hire_primary_start_at_date)

    @crane_hire_booking.is_admin = true

    if @crane_hire_booking.save
      smart_bookings_list_redirect
    else
      render :action => :new
    end
  end

  def update
    @crane_hire_booking = CraneHireBooking.find(params[:id])
    @crane_hire_booking.assign_attributes(params[:crane_hire_booking])
    @crane_hire_booking.set_charge # price might have changed

    @default_time_slots = CraneHireBooking.default_time_slots
    @booked_time_slots = CraneHireBooking.booked_time_slots(@crane_hire_booking.crane_size, @crane_hire_booking.crane_hire_primary_start_at_date)

    if @crane_hire_booking.save
      smart_bookings_list_redirect
    else
      setup_form_data()
      render :action => :edit
    end
  end

  destroy do
    wants.html {
      smart_bookings_list_redirect
    }
  end

  def payment_list
    @crane_hire_bookings = collection.reorder('crane_hire_primary_start_at desc')
  end

  def full_list
    @crane_hire_bookings = collection.reorder('crane_hire_primary_start_at desc')
  end

  def print
    @print_layout_class = 'print-layout'
    @crane_hire_bookings = collection
    render :layout => 'print'
  end

  private
  def collection
    collection = end_of_association_chain

    collection = collection.order('crane_hire_primary_start_at asc')

    per = 100

    if (@date = params[:date]).present?
      collection = collection.by_date(@date)
      per = 1000
    end

    # @directions = ['asc', 'desc']
    # @order_dir = (params[:order_dir] || 'asc')
    # @reverse_order_dir = (@directions - [@order_dir]).first

    # if (params[:order])
    #   @selected_column_attr = params[:order]

    #   if params[:order] == 'crane_hire'
    #     collection = collection.order('crane_hire_primary_start_at ' + @order_dir)
    #   elsif params[:order] == 'cradle'
    #     collection = collection.order('cradle_hire_start_at ' + @order_dir)
    #   end
    # end

    collection = collection.page(params[:page]).per(per)

    # paid_or_admin.
  end

  def smart_bookings_list_redirect
    if request.referer =~ /admin_list/ || params[:admin_list].present?
      redirect_to admin_list_admin_crane_hire_bookings_path
    else
      redirect_to admin_crane_hire_bookings_path
    end
  end
end

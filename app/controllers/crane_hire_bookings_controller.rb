class CraneHireBookingsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include CraneHireBookingHelper

  def index
    redirect_to :action => :new
  end

  def new
    @crane_hire_booking = CraneHireBooking.new
    @crane_hire_booking.is_member = 1

    if Rails.env.development?
      @crane_hire_booking.owner_name = "Dermot Brennan"
      @crane_hire_booking.mobile = "12342342"
      @crane_hire_booking.email = "dermot.brennan@isobar.com"
      @crane_hire_booking.boat_name = "Boat 145"
      @crane_hire_booking.boat_type = "one design"
      @crane_hire_booking.loa = "13"
    end

    setup_form_data()
  end

  def create
    @crane_hire_booking = CraneHireBooking.new
    @crane_hire_booking.assign_attributes(params[:crane_hire_booking])

    if current_user && current_user.is_admin?
      @crane_hire_booking.is_admin = true
    end

    if @crane_hire_booking.save
      # redirect_to payment_crane_hire_booking_path(@crane_hire_booking)
      redirect_to thank_you_crane_hire_bookings_path()
    else
      setup_form_data()
      date = @crane_hire_booking.crane_hire_primary_start_at_date
      crane_size = @crane_hire_booking.crane_size
      @booked_time_slots = CraneHireBooking.booked_time_slots(crane_size, date)
      render :action => :new
    end
  end

  def thank_you
  end

  def time_slots
    @default_time_slots = CraneHireBooking.default_time_slots
    date = params[:date]
    crane_size = params[:crane_size]
    if date.present? && crane_size.present?
      @booked_time_slots = CraneHireBooking.booked_time_slots(crane_size, date)
    elsif date.blank?
      @error_msg = "Please select a date"
    elsif crane_size.blank?
      @error_msg = "Please select a crane size"
    end
    render :layout => false
  end

  def total_charge
    @crane_hire_booking = CraneHireBooking.new(params[:crane_hire_booking])
    render :layout => false
  end

  def payment
    @crane_hire_booking = CraneHireBooking.find(params[:id])
    @payment_item = PaymentItem.new(params[:payment_item])
    @payment_item.ip_address = request.remote_ip.to_s  # securely assign
    @payment_item.user_agent = request.user_agent.to_s  # securely assign
    @payment_item.product = @crane_hire_booking

    # the cost of the new package
    @payment_item.amount = @crane_hire_booking.total_charge
    @payment_item.currency = 'EUR'

    # assign this latest payment item to our order
    @crane_hire_booking.payment_item = @payment_item

    if request.post? || request.put?
      if @crane_hire_booking.paid?
        @payment_item.errors.add(:base, "This order has already been paid")
        return
      end

      @payment_item.card_validation
      if @payment_item.valid? && @payment_item.save!
        gateway_resp = @payment_item.purchase

        if Rails.env.production? && gateway_resp.enrolled? # only enable 3d secure in production
          @crane_hire_booking.save # save the order because we have a valid payment item

          # user is enrolled in 3d secure, we need to redirect them to somewhere...
          @payment_item.pareq = gateway_resp.pa_req
          @payment_item.acsurl = gateway_resp.acs_url
          enter_3d_secure
          return
        elsif gateway_resp.success?
          @crane_hire_booking.save # save the order because we have a valid payment item
          @payment_item.update_attribute(:authorization, gateway_resp.authorization)
          finalize_purchase
        else
          status = gateway_resp.params["Status"]
          @payment_item.errors.add(:base, "Error from payment gateway: " + gateway_resp.message)
        end
      end
    end
  end

  def enter_3d_secure
    @payment_item = @crane_hire_booking.payment_item # @crane_hire_booking comes from the action that called this method
    render :action => 'enter_3d_secure'
  end

  def complete_3d_secure
    @crane_hire_booking = CraneHireBooking.find(params[:id])
    @payment_item = @crane_hire_booking.payment_item

    @pa_res = params['PaRes']
    @md = params['MD']

    if request.post?
      if @pa_res.present? && @md.present?
        # begin
          @payment_item.decrypt_md(@md) # reimport the encrypt cc details back into the payment item object

          # 3ds-verifysig and if thats successful it will do a regular purchase
          gateway_resp = @payment_item.purchase(:three_d_secure_auth => {:pa_res => @pa_res})

          if gateway_resp.success?
            finalize_purchase
          else
            # flash[:error] = "3D Secure failure: failed to complete"
            flash[:error] = gateway_resp.message
            redirect_to :action => :payment, :id => @crane_hire_booking.id
            return
          end
        # rescue Exception => oe
        #   Rails.logger.debug oe.backtrace
        #   flash[:error] = t("unable_to_authorize_credit_card") + ": #{oe.message}"
        #   redirect_to payment_event_entry_path(@entry, :event_id => @entry.event.id) and return
        # end
      else
        flash[:error] = "3D Secure failure: missing PARes and MD parameters"
        redirect_to :action => :payment, :id => @crane_hire_booking.id
        return
      end
    end
  end

  private
  def use_https?
    true
  end

  def finalize_purchase
    # update entry payment status
    @crane_hire_booking.mark_as_paid!
    # # send email to admin
    # Notifier.crane_hire_booking_admin(@crane_hire_booking).deliver
    # # send email to member
    # Notifier.crane_hire_booking_confirmation(@crane_hire_booking).deliver
    # redirect to thank you
    redirect_to action: :thank_you
  end

end

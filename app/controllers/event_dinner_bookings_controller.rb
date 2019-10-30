class EventDinnerBookingsController < ApplicationController
  include ActionView::Helpers::NumberHelper

  before_filter :load_event

  def index
    redirect_to :action => :new
  end

  def new
    @event_dinner_booking = @event_dinner.bookings.build
    @event_dinner_booking.quantity = 1

    if Rails.env.development?
      @event_dinner_booking.name = "Dermot Brennan"
      @event_dinner_booking.phone = "12342342"
      @event_dinner_booking.email = "dermot.brennan@isobar.com"
      @event_dinner_booking.table_name = "Boat 145"
    end
  end

  def create
    @event_dinner_booking = @event_dinner.bookings.build(params[:event_dinner_booking])

    if current_user && current_user.is_admin?
      @event_dinner_booking.is_admin = true
    end

    if @event_dinner_booking.save
      # redirect_to payment_event_dinner_booking(@event_dinner_booking)
      redirect_to thank_you_event_event_dinner_bookings_path(:event_id => @event.id)
    else
      render :action => :new
    end
  end

  def thank_you
  end

  def total_charge
    @event_dinner_booking = @event_dinner.bookings.build(params[:event_dinner_booking])
    render :layout => false
  end

  def payment
    @event_dinner_booking = EventDinnerBooking.find(params[:id])
    @payment_item = PaymentItem.new(params[:payment_item])
    @payment_item.ip_address = request.remote_ip.to_s  # securely assign
    @payment_item.user_agent = request.user_agent.to_s  # securely assign
    @payment_item.product = @event_dinner_booking

    # the cost of the new package
    @payment_item.amount = @event_dinner_booking.total_charge
    @payment_item.currency = 'EUR'

    # assign this latest payment item to our order
    @event_dinner_booking.payment_item = @payment_item

    if request.post? || request.put?
      if @event_dinner_booking.paid?
        @payment_item.errors.add(:base, "This order has already been paid")
        return
      end

      @payment_item.card_validation
      if @payment_item.valid? && @payment_item.save!
        gateway_resp = @payment_item.purchase

        if Rails.env.production? && gateway_resp.enrolled? # only enable 3d secure in production
          @event_dinner_booking.save # save the order because we have a valid payment item

          # user is enrolled in 3d secure, we need to redirect them to somewhere...
          @payment_item.pareq = gateway_resp.pa_req
          @payment_item.acsurl = gateway_resp.acs_url
          enter_3d_secure
          return
        elsif gateway_resp.success?
          @event_dinner_booking.save # save the order because we have a valid payment item
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
    @payment_item = @event_dinner_booking.payment_item # @event_dinner_booking comes from the action that called this method
    render :action => 'enter_3d_secure'
  end

  def complete_3d_secure
    @event_dinner_booking = EventDinnerBooking.find(params[:id])
    @payment_item = @event_dinner_booking.payment_item

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
            redirect_to :action => :payment, :id => @event_dinner_booking.id
            return
          end
        # rescue Exception => oe
        #   Rails.logger.debug oe.backtrace
        #   flash[:error] = t("unable_to_authorize_credit_card") + ": #{oe.message}"
        #   redirect_to payment_event_entry_path(@entry, :event_id => @entry.event.id) and return
        # end
      else
        flash[:error] = "3D Secure failure: missing PARes and MD parameters"
        redirect_to :action => :payment, :id => @event_dinner_booking.id
        return
      end
    end
  end

  def list
    @event_dinner_bookings = @event_dinner.try(:bookings)
  end

  private
  def finalize_purchase
    # update entry payment status
    @event_dinner_booking.mark_as_paid!
    # # send email to admin
    # Notifier.event_dinner_booking(@event_dinner_booking).deliver
    # # send email to member
    # Notifier.event_dinner_booking(@event_dinner_booking).deliver
    # redirect to thank you
    redirect_to action: :thank_you
  end

  def load_event
    @event = Event.find(params[:event_id])
    @event_dinner = @event.event_dinner
  end
end

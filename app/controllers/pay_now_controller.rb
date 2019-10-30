class PayNowController < ApplicationController
  protect_from_forgery :except => [:complete_3d_secure, :enter_3d_secure]

  def index
    @order = Order.new
    @product_categories = ProductCategory.order('position asc').includes(:products)
  end

  def create
    ## save new order
    @order = Order.new(params[:order])

    if @order.save
      flash[:success] = 'Order Saved!'

      redirect_to :action => :pay, :order_id => @order.id
    else
      @product_categories = ProductCategory.order('position asc').includes(:products)
      render :action => :index
    end
  end

  def pay
    @order = Order.find(params[:order_id])
    @payment_item = PaymentItem.new(params[:payment_item])
    @payment_item.ip_address = request.remote_ip.to_s  # securely assign
    @payment_item.user_agent = request.user_agent.to_s  # securely assign
    @payment_item.product = @order

    # the cost of the new package
    @payment_item.amount = @order.total
    @payment_item.currency = 'EUR'

    # assign this latest payment item to our order
    @order.payment_item = @payment_item

    if request.post? || request.put?
      if @order.paid?
        @payment_item.errors.add(:base, "This order has already been paid")
        return
      end

      @payment_item.card_validation
      if @payment_item.valid? && @payment_item.save!
        gateway_resp = @payment_item.purchase

        if Rails.env.production? && gateway_resp.enrolled? # only enable 3d secure in production
          @order.save # save the order because we have a valid payment item

          # user is enrolled in 3d secure, we need to redirect them to somewhere...
          @payment_item.pareq = gateway_resp.pa_req
          @payment_item.acsurl = gateway_resp.acs_url
          enter_3d_secure
          return
        elsif gateway_resp.success?
          @order.save # save the order because we have a valid payment item
          @payment_item.update_attribute(:authorization, gateway_resp.authorization)
          finalize_entry_purchase
        else
          status = gateway_resp.params["Status"]
          @payment_item.errors.add(:base, "Error from payment gateway: " + gateway_resp.message)
        end
      end
    end
  end

  def enter_3d_secure
    @payment_item = @order.payment_item
    render :action => 'enter_3d_secure'
  end

  def complete_3d_secure
    @order = Order.find(params[:order_id])
    @payment_item = @order.payment_item

    @pa_res = params['PaRes']
    @md = params['MD']

    if request.post?
      if @pa_res.present? && @md.present?
        # begin
          @payment_item.decrypt_md(@md) # reimport the encrypt cc details back into the payment item object

          # 3ds-verifysig and if thats successful it will do a regular purchase
          gateway_resp = @payment_item.purchase(:three_d_secure_auth => {:pa_res => @pa_res})

          if gateway_resp.success?
            finalize_entry_purchase
          else
            # flash[:error] = "3D Secure failure: failed to complete"
            flash[:error] = gateway_resp.message
            redirect_to :action => :pay, :order_id => @order.id
            return
          end
        # rescue Exception => oe
        #   Rails.logger.debug oe.backtrace
        #   flash[:error] = t("unable_to_authorize_credit_card") + ": #{oe.message}"
        #   redirect_to payment_event_entry_path(@entry, :event_id => @entry.event.id) and return
        # end
      else
        flash[:error] = "3D Secure failure: missing PARes and MD parameters"
        redirect_to :action => :pay, :order_id => @order.id
        return
      end
    end
  end

  def thank_you
    @order = Order.find(params[:order_id])
  end

  private
  def use_https?
    true
  end

  def finalize_entry_purchase
    # update entry payment status
    @order.mark_as_paid!
    # send email to admin
    Notifier.order_admin(@order).deliver
    # send email to member
    Notifier.order_confirmation(@order).deliver
    # redirect to thank you
    redirect_to action: :thank_you, :order_id => @order.id
  end
end
class EntriesController < ApplicationController
  include PaymentItemsHelper
  include ChargesHelper
  include Admin::EntryOrderingHelper
  before_filter :load_entry, :authorize_entry, :only => [:payment, :enter_3d_secure, :complete_3d_secure, :thank_you]
  protect_from_forgery :except => [:complete_3d_secure, :enter_3d_secure]

  def new
    # render :text => "ok"
    @event = Event.find(params[:event_id])
    # Rails.logger.debug("total number of entries: #{@event.total_number_of_entries}")
    # render :text => @event.total_number_of_entries
    
    # @temp_event = Event.find(event.id)
    # if @temp_event.entry_form
    #   @entries = @temp_event.entries.includes(:boat_class, :club, :fleet)
    #   @entries = @entries.paid

    #   if @temp_event.total_number_of_entries.present?
    #     if @entries.count >= @temp_event.total_number_of_entries
    #       @normal_number_of_entries.push(true)
    #       # @normal_number_of_entries[index].push(true)
    #       # event.insert('asdf')
    #     else
    #       @normal_number_of_entries.push(false)
    #     end
    #   end

    # end
    # @event.entry_lists.admin.first.entry_list_columns.count

    # if @event.entry_lists.admin.first.present? && @event.entry_lists.admin.first.entry_list_columns.count == @event.total_number_of_entries
    if @event.entries.paid.present? && !@event.total_number_of_entries.nil? && @event.entries.paid.count >= @event.total_number_of_entries
      redirect_to url_for(:action => :index), :alert => "Training Event Full"
    end

    if @event.entry_form
        @entry = Entry.new(:entry_form_id => @event.entry_form.id)
        @entry.set_charges
    else
      flash[:error] = "No entry form for this event"
      redirect_to events_path
    end
  end

  def show
    redirect_to events_path
  end

  def create
    preprocess_charges_params
    
    @entry = Entry.new(params[:entry])
    @event = @entry.event
    @entry.generate_booking_reference
    @entry.set_charges

    if @event.event_type == "training"
      if @entry.valid?
        if @entry.save
          (session[:entry_ids] ||= []) << @entry.id
          redirect_to generate_url(ENV['PAYMENT_URL'], product_id: @event.title, comment_1: @entry.owner_name, comment_2: @entry.boat_name, variable_reference: get_variable_reference,ledger_payments: get_ledger_payments,entry_unique_booking_reference: @entry.entry_unique_booking_reference ,callback_url: payment_confirmation_url + '/')
        else
          render :action => :new
        end
      else
        if @entry.owner_name == ""
          @entry.errors.delete(:owner_name)
          keys = @entry.errors.keys()
          values = @entry.errors.values()
          @entry.errors.clear()
          @entry.errors.add(:base, 'Student Name can\'t be blank')
          index = 0
          keys.each do |key|
            @entry.errors.add(key, values[index][0])
            index = index + 1
          end
        end
        
        render :action => :new
      end
    else
      if @entry.save
        (session[:entry_ids] ||= []) << @entry.id
        redirect_to generate_url(ENV['PAYMENT_URL'], product_id: @event.title, comment_1: @entry.owner_name, comment_2: @entry.boat_name, variable_reference: get_variable_reference,ledger_payments: get_ledger_payments,entry_unique_booking_reference: @entry.entry_unique_booking_reference ,callback_url: payment_confirmation_url + '/')
      else
        render :action => :new
      end
    end

  end

  def edit
  end

  def update
  end

  def payment
    @event = @entry.event
    @entry.total

    @payment_item = PaymentItem.new(params[:payment_item])
    @payment_item.ip_address = request.remote_ip.to_s # securely assign
    @payment_item.user_agent = request.user_agent.to_s # securely assign
    @payment_item.user_id = current_user.try(:id)
    @payment_item.product = @entry

    # the cost of the new package
    @payment_item.amount = @entry.total
    @payment_item.currency = 'EUR'

    # assign this latest payment item to our entry
    @entry.payment_item = @payment_item

    if request.post?
      if @entry.paid?
        @payment_item.errors.add(:base, "This entry has already been paid")
        return
      end

      @payment_item.card_validation
      if @payment_item.valid? && @payment_item.save!
        gateway_resp = @payment_item.purchase

        if gateway_resp.enrolled?
          @entry.save # save the entry because we have a valid payment item

          # user is enrolled in 3d secure, we need to redirect them to somewhere...
          @payment_item.pareq = gateway_resp.pa_req
          @payment_item.acsurl = gateway_resp.acs_url
          enter_3d_secure
          return
        elsif gateway_resp.success?
          @entry.save # save the entry because we have a valid payment item
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
    @event = @entry.event
    @payment_item = @entry.payment_item
    render :action => 'enter_3d_secure'
  end

  def complete_3d_secure
    @payment_item = @entry.payment_item

    @pa_res = params['PaRes']
    @md = params['MD']

    if request.post?
      if @pa_res.present? && @md.present?
        # begin
        @payment_item.decrypt_md(@md) # reimport the encrypt cc details back into the payment item object

        # 3ds-verifysig and if thats successul it will do a regular purchase
        #@payment_item.pa_ref = params['']
        gateway_resp = @payment_item.purchase(:three_d_secure_auth => {:pa_res => @pa_res})

        if gateway_resp.success?
          finalize_entry_purchase
        else
          # flash[:error] = "3D Secure failure: failed to complete"
          flash[:error] = gateway_resp.message
          redirect_to payment_event_entry_path(@entry, :event_id => @entry.event.id) and return
        end
        # rescue Exception => oe
        #   Rails.logger.debug oe.backtrace
        #   flash[:error] = t("unable_to_authorize_credit_card") + ": #{oe.message}"
        #   redirect_to payment_event_entry_path(@entry, :event_id => @entry.event.id) and return
        # end
      else
        flash[:error] = "3D Secure failure: missing PARes and MD parameters"
        redirect_to payment_event_entry_path(@entry, :event_id => @entry.event.id) and return
      end
    end
  end

  def thank_you
    @event = @entry.event
  end

  def index
    @event = Event.find(params[:event_id])
    # render :text => @event.total_number_of_entries
    if @event.entry_form
      @selected_entry_list = @event.entry_lists.public_lists.first
      # render :text => @selected_entry_list.entry_list_columns[0].inspect
      # Rails.logger.debug("count: #{@selected_entry_list.entry_list_columns.count}")
      @order, @order_dir = get_admin_entry_ordering()

      # entry list columns
      @selected_entry_list_columns = []
      if @selected_entry_list.present?
        @selected_entry_list.entry_list_columns.each do |entry_column|
          @selected_entry_list_columns.push(entry_column.entry_attr)
        end
      end

      # Rails.logger.debug("count of entries: #{@selected_entry_list_columns.count}")
      
      @entries = @event.entries.includes(:boat_class, :club, :fleet)
      
      
      if @order
        @entries = @entries.order("#{@order} #{@order_dir}")
      end
      @entries = @entries.paid.page(params[:page]).per(params[:per] || 100)
      # render :text => @event.total_number_of_entries

      if @event.total_number_of_entries.present?
        if @entries.count >= @event.total_number_of_entries
          flash.now.notice = "Training Event Full"
          @normal_number_of_entries = true
        end
      end

    end
  end

  # return price of entry with these charges applied
  def charge_total
    @entry = Entry.new(:entry_form_id => EntryForm.find(params[:entry_form_id]).id)
    @entry.charges_accepted = Charge.find(params[:charge_ids]) if params[:charge_ids].present?
    @entry.charge_values = params[:charge_values]
    use_default = (params[:is_frontend].present? && params[:is_frontend] == 'true')
    @entry.set_charges(use_default)
    render :layout => false
  end

  private

  def use_https?
    true
  end

  #Delegator Action Item can we total out of this and incorporate into hash

  def get_ledger_payments
    ledger_payments = []
    @entry.charges.each do |charge|
      payment = {
          payment_category: charge.name,
          date: DateTime.now.iso8601,
          check_number: charge.account_code,
          amount: charge.price
      }
      ledger_payments << payment
    end
    ledger_payments.to_json
  end

  def get_variable_reference
    variable_reference = ""
    @entry.charges.each do |charge|
      if variable_reference.blank?
        variable = charge.account_code.to_s + "_" + charge.price.to_s
      else
        variable = "_" + charge.account_code.to_s + "_" + charge.price.to_s
      end
      variable_reference += variable
    end
    variable_reference
  end

  def generate_url(url, params = {})
    uri = URI(url)
    uri.query = params.to_query
    uri.to_s
  end



  def load_entry
    @entry = Entry.find(params[:id])
  end

  def authorize_entry
    unless @entry && session[:entry_ids].present? && session[:entry_ids].include?(@entry.id)
      redirect_to url_for(:action => :new), :alert => "You are not authorized to access that entry"
    end
  end

  def finalize_entry_purchase
    # update entry payment status
    @entry.mark_as_paid!
    # give it an entry number specific to this event
    @entry.set_entry_number!
    # send email
    Notifier.entry(@entry).deliver
    # redirect to thank you
    redirect_to thank_you_event_entry_path(@entry, :event_id => @entry.event)
  end
end

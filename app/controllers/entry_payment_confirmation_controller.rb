require 'digest'
class EntryPaymentConfirmationController < ApplicationController
  def index
    @entry_paid = false
    unless params[:entry_unique_booking_reference].nil? && params[:payment_status].nil? && params[:signature].nil?
      @entry = Entry.find_by_entry_unique_booking_reference(params[:entry_unique_booking_reference])
      if compare_signature(params[:entry_unique_booking_reference], params[:signature])
        if !@entry.nil? && @entry.paid? == false && params[:payment_status] == "success"
          @entry.mark_as_paid!
          @entry_paid = true
          flash.now[:success] = 'You payment has been successfully processed!'
        elsif !@entry.nil? && @entry.paid? == true && params[:payment_status] == "fail"
          flash.now[:alert] = 'Your Entry has been already processed!'
        else
          flash.now[:alert] = 'An Error has happened and we are unable to process your payment!'
        end
      else
        flash.now[:alert] = 'An Error has happened and we are unable to process your payment!'
      end
    else
      flash.now[:notice] = 'There no parameters has been passed!'
    end
  end

  private

  #Delegator Integration
  #Delegator Action Item hashed_booking needs to include total
  #Delegator Action Item secret needs to be moved out of code

  def compare_signature(booking_ref, signature)
    secret = "mcgeesium602bb8d4ac3f53ce22c269"
    hashed_booking = Digest::MD5.hexdigest(secret + booking_ref)
    hashed_booking == signature ? true : false
  end
end






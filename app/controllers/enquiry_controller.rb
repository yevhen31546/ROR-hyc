class EnquiryController < ApplicationController

  def index
    @contact_us = ContactUs.new(params[:contact_us])
    return unless request.post? && @contact_us.valid?
    @contact_us.save!
    Notifier.admin_contact_us(@contact_us).deliver # sends the email
    flash[:success] = 'Mail submitted successfully'
    redirect_to :root; return
  end

  private
  def use_https?
    true
  end
end

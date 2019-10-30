class Notifier < ActionMailer::Base
  include SettingsUtils
  include ApplicationHelper
  helper :application

  def contact_us(contact_us)
    @contact_us = contact_us
    mail(:from => email_from, :to => email_to,
      :subject => "New Contact - #{@contact_us.name} - #{get_site_name}")
  end

  def admin_contact_us(contact_us)
    @contact_us = contact_us
    mail(:from => email_from, :to => email_to_office,
      :subject => "New Enquiry - #{@contact_us.name} - #{get_site_name}")
  end

  def password_reset_instructions(user)
    @reset_password_url = reset_password_url(user.perishable_token)
    mail(:from => email_from, :to => user.email,
      :subject => "Password Reset Instructions - #{get_site_name}")
  end

  def subscription(subscription)
    @subscription = subscription
    mail(:from => email_from, :to => email_to,
      :subject => "New Newsletter Subscription - #{@subscription.email} - #{get_site_name}")
  end

  def entry(entry)
    @entry = entry
    mail(:from => email_from, :to => email_to,
      :subject => "New Entrant to #{@entry.event.try(:title)} - #{@entry.email} - #{get_site_name}")
  end

  def order_admin(order)
    @order = order
    mail(:from => email_from, :to => order_email_to,
      :subject => "Payment Received - #{order.reference}")
  end

  def order_confirmation(order)
    @order = order
    mail(:from => email_from, :to => order.email,
      :subject => "Payment Receipt - #{order.reference}")
  end
def test
	mail(:from=> email_from, :to => "mail@somesh.info", :subject=> "Test")
end
  private
  def email_from
    settings[:system_email] # e.g. 'Example.com <system@example.com>'
  end

  def email_to
    Rails.env.production? ? settings[:contact_email] : 'dermot.brennan@isobar.com'
  end

  def email_to_office
    Rails.env.production? ? settings[:office_contact_email] : 'dermot.brennan@isobar.com'
  end

  def order_email_to
    Rails.env.production? ? settings[:office_contact_email] : 'dermot.brennan@isobar.com'
  end
end

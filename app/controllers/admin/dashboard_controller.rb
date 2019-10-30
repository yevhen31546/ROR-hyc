require 'open-uri'

class Admin::DashboardController < Admin::BaseController
  skip_before_filter :can_access_current_module?

  def index
  end

  def announcements_ajax
    data = open('http://www.lucidity.ie/announcements_ajax')
    send_data data.read, :type => 'text/html', :disposition => 'inline'
  end
end

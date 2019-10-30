# encoding: UTF-8
require 'authenticated_system'

class ApplicationController < ActionController::Base

  # def forem_user
  #   current_user
  # end

  # helper_method :forem_user, 
  helper_method :is_admin_area?

  protect_from_forgery

  include AuthenticatedSystem
  include Admin::PaginationHelper

  ######### SSL stuff ##########
  before_filter :https_redirect

  def https_redirect
    if ENV["ENABLE_HTTPS"] == "yes"
      if request.ssl? && !use_https? || !request.ssl? && use_https?
        protocol = request.ssl? ? "http" : "https"
        flash.keep
        redirect_to protocol: "#{protocol}://", status: :moved_permanently
      end
    end
  end

  def use_https?
    false # Override in other controllers
  end

  def is_admin_area?
    false
  end
end

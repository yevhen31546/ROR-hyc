require 'admin_system'

class Admin::BaseController < ApplicationController
  before_filter :require_admin, :can_access_current_module?, :active_modules
  include AdminSystem
  include Admin::AdminHelper
  include Admin::PaginationHelper
  layout proc {|controller| controller.request.xhr? ? nil : 'admin' }
  helper_method :current_module

#  before_filter :set_no_layout_if_xhr, :only => [:new, :edit]
#
#  private
#  def set_no_layout_if_xhr
#    render :layout => false
#  end

  private
  def use_https?
    true
  end

  def is_admin_area?
    true
  end
end

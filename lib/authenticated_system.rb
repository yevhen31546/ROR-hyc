module AuthenticatedSystem

  def self.included(base)
    # make available as ActionView helper methods.
    base.send(:helper_method, :current_user_session, :current_user, :logged_in?, :is_admin?)
  end

private
  def logged_in?
    #Rails.logger.debug session.inspect
    !!current_user
  end

  def is_editor?
    logged_in? && current_user.is_editor?
  end

  def is_admin?
    logged_in? && current_user.is_admin?
  end

  def is_superadmin?
    logged_in? && current_user.is_superadmin?
  end

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end

  def require_user
    return if logged_in?
    store_location
    flash[:notice] = 'You must be logged in to access this page'
    redirect_to login_url; return false
  end

  def require_no_user
    return unless logged_in?
    store_location
    flash[:notice] = 'You must be logged out to access this page'
    redirect_to account_url; return false
  end

  def require_admin
    return if is_admin? || is_editor?
    store_location
    flash[:notice] = 'You must be logged in as an admin to access this page'
    redirect_to (logged_in? ? account_url : login_url); return false
  end

  def require_superadmin
    return if is_superadmin?
    store_location
    flash[:notice] = 'You must be logged in as an superadmin to access this page'
    redirect_to (logged_in? ? account_url : login_url); return false
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default, options = {})
    referer = request.referer unless request.referer =~ /login$/
    location = session[:return_to] || referer || default
    redirect_to location, options
    session[:return_to] = nil
    true # return true here so that you can use this => redirect_back_or_default(...) and return
  end

end

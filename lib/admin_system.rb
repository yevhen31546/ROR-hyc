module AdminSystem
  def current_module
    @current_module ||= AdminModule.where(:controller => controller_name).first
  end

  def can_access_current_module?
    unless current_user.has_access_to_admin_module?(current_module)
      store_location
      flash[:notice] = 'Sorry you are not authorized to access this page'
      redirect_to admin_path
    end
  end

  def active_modules
    if current_module and current_module.children.present?
      @modules = current_module.children
    elsif current_module and current_module.parent.present?
      @modules = current_module.parent.children
    else
      @modules = AdminModule.where(:parent_id => nil)
    end
    if current_user.is_superadmin?
      @modules = @modules.superadmin_active
    elsif current_user.is_admin?
      @modules = @modules.active
    elsif current_user.is_editor?
      @modules = current_user.admin_modules
    end
  end
end

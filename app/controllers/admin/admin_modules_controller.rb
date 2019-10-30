class Admin::AdminModulesController < Admin::BaseController
  # before_filter :require_superadmin, :active_modules
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  def index
    if params[:admin_modules] && !params[:admin_modules].empty?
      params[:admin_modules].each_pair do |id, attribs|
        AdminModule.find(id).update_attributes(attribs.slice("active", "superadmin_active"))
      end
    end
  end

  def create
    if params[:admin_module] && !params[:admin_module].empty?
      AdminModule.create(params[:admin_module])
    end
    flash[:success] = "Admin Modules updated successfully"
    redirect_to :action => 'index'; return
  end
end

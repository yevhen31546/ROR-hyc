class Admin::NavbarItemsController < Admin::BaseController
  resource_controller

  new_action.before do
    if params[:navbar_id]
      object.navbar_id = params[:navbar_id]
    end
  end
  
  edit do
    wants.html do
      if request.xhr?
        render '/admin/navbar_items/_form', :layout => false
      end
    end
  end

  create do
    wants.html { redirect_to admin_navbars_path }
    wants.json { 
      flash.discard
      render :json => {'id' => object.id} }
    wants.js { flash.discard
      render }
  end

  update do
    wants.html { request.xhr? ? head(:ok) : redirect_to(admin_navbars_path) }
    wants.js {
      flash.discard
      head :ok }
  end
  
  destroy do
    wants.html { 
      redirect_to admin_navbars_path }
    wants.js {
      flash.discard
      head :ok }
  end

end

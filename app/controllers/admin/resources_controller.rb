class Admin::ResourcesController < Admin::BaseController
  resource_controller
  skip_before_filter :verify_authenticity_token, :only => [:create]  # Workaround for CKEditor not passing the authenticity token
  before_filter :set_layout

  def show
    redirect_to :action => 'index'
  end

  create do
    before do
      if params[:upload]
        object.asset = params[:upload]
        object.name = object.asset.original_filename
      end
    end
    wants.html do
      if @layout_false
        render :layout => false
        flash[:notice] = nil
        flash[:success] = nil
      else
        redirect_to admin_resources_path
      end
    end
  end

  def set_layout
    if params[:layout] == 'false' || (params[:resource] && params[:resource][:layout] == 'false')
      @layout_false = true
      @stylesheets = ['admin/assets_layout_false.css']
    end
  end

private
  def collection
    end_of_association_chain.page(params[:page])
  end  

end

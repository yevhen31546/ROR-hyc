class Admin::AssetsController < Admin::BaseController
  skip_before_filter :verify_authenticity_token, :only => [:create]  # Workaround for CKEditor not passing the authenticity token
    
  layout 'assets_popup'

  def show
    redirect_to :action => 'index'
  end

  def index
    @asset_type = params[:type]
    @category = params[:category]
    @select_type = params[:select_type]
    @assets = Asset.where(:type => params[:type], :category => params[:category])
    if request.xhr?
      render :partial => 'admin/assets/index', :locals => {:assets => @assets}
    end
  end

  def thumbnail
    asset = Asset.find(params[:id])
    render :partial => 'thumbnail', :locals => {:asset => asset}
  end

  def create
    asset = params[:type].constantize.new(:asset => params[:file], 
      :category => params[:category])
    if @asset_type == 'Image'
       asset.width = 200
       asset.height = 200
    end
    asset.name = asset.asset.original_filename
    if asset.save
      head :ok
    else
      head 500
    end
  end
end

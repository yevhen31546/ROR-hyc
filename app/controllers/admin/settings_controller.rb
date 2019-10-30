class Admin::SettingsController < Admin::BaseController
  resource_controller

  def index
  end

  def update_all
    if request.post? && params[:settings]
      params[:settings].each do |setting_attrs|
        Setting.find(setting_attrs[:id]).update_attribute(:value, setting_attrs[:value])
      end
      flash[:success] = "Settings updated successfully"
      redirect_to :action => 'index'; return
    end
  end

  def new
    @setting = Setting.new
  end

  def edit
    @setting = Setting.find(params[:id])
  end

  def create
    @setting = Setting.new(params[:setting])
    if @setting.save
      redirect_to url_for(:action => :new), :notice => "Setting added successfully"
    else
      render :action => :new
    end
  end

  def update
    @setting = Setting.find(params[:id])
    @setting.attributes = params[:setting]
    if @setting.save
      redirect_to url_for(:action => :index), :notice => "Setting updated successfully"
    else
      render :action => :edit
    end
  end

  def destroy
    @setting = Setting.find(params[:id])
    @setting.destroy
    redirect_to url_for(:action => :index), :notice => "Setting deleted"
  end
end

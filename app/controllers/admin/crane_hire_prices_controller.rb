class Admin::CraneHirePricesController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  index.before do
    @crane_hire_price = CraneHirePrice.new()
  end

  def create
    @object = @crane_hire_price = CraneHirePrice.new(params[:event_resource])
    if @crane_hire_price.save
      redirect_to admin_crane_hire_prices_path
    else
      render :action => :index
    end
  end

  update do
    wants.html {
      redirect_to admin_crane_hire_prices_path
    }
  end

  destroy do
    wants.html {
      redirect_to admin_crane_hire_prices_path
    }
  end

private
  def collection
    end_of_association_chain.page(params[:page])
  end

end

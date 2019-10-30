class Admin::CountriesController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => :index
  end

  private
  def collection
    end_of_association_chain.page(params[:page])
  end
end 

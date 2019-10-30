class Admin::ProductCategoriesController < Admin::BaseController
 resource_controller

  def show
    redirect_to :action => 'index'
  end

  create do
    wants.html { redirect_to :action => :index }
  end

  update do
    wants.html { redirect_to :action => :index }
  end

  private
  def collection
    end_of_association_chain.page(params[:page])
  end
end
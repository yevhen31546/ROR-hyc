class Admin::ProductsController < Admin::BaseController
 resource_controller

  def show
    redirect_to :action => 'index'
  end

  private
  def collection
    end_of_association_chain.includes(:product_category).order('product_categories.position asc, products.position asc').page(params[:page]).per(100)
  end
end
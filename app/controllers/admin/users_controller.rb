class Admin::UsersController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  private
  def collection
    @collection = end_of_association_chain
    @collection = @collection.includes(:role).where("roles.name != ?", "superadmin")
    if (@query = params[:query]).present?
      @collection = @collection.by_query(@query)
    end
    @collection.page(params[:page])
  end
end

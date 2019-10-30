class Admin::CommitteesController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end 

  private
  def collection
    page_param = params[:page].is_a?(HashWithIndifferentAccess) ? 1 : params[:page]
    @collection = end_of_association_chain.page(params[:page])
  end
end

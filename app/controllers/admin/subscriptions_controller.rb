class Admin::SubscriptionsController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  def copy_paste
  end

private
  def collection
    end_of_association_chain.page(params[:page])
  end  

end

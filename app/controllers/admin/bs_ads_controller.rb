class Admin::BsAdsController < Admin::BaseController
  resource_controller

  def show
    redirect_to :action => 'index'
  end

  def index

    @order = @selected_column_attr = params[:order] || 'created_at'

    @order_dirs = ['asc', 'desc']
    @order_dir = (params[:order_dir] || @order_dirs.first)

    @order_dirs_copy = @order_dirs.dup
    @order_dirs_copy.delete(@order_dir)
    @reverse_order_dir = @order_dirs_copy.first

    allowable_orders = ['name', 'contact_name', 'created_at']
    @order = nil unless allowable_orders.include?(@selected_column_attr)



    @bs_ads = collection()
  end

  def activate
    ad = BsAd.find(params[:id])
    # ad.calculate_dates
    if ad.activate!
      redirect_to :back, :notice => "Ad is now active"
    else
      redirect_to :back, :notice => "Could not make ad active"
    end
  end

  def deactivate
    ad = BsAd.find(params[:id])
    if ad.deactivate!
      redirect_to :back, :notice => "Ad is now inactive"
    else
      redirect_to :back, :notice => "Could not make ad inactive"
    end
  end

  private
  def collection
    page_param = params[:page].is_a?(HashWithIndifferentAccess) ? 1 : params[:page]
    @collection = end_of_association_chain.page(params[:page])
    @collection = @collection.order("#{@order} #{@order_dir}")
    @collection = @collection.page(params[:page]).per(100)
    @collection = @collection.not_deleted
  end
end

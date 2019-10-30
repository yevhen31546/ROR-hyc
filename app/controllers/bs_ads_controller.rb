class BsAdsController < ApplicationController

  resource_controller :except => :index

  create.before do
    object.status = 'active'
  end

  def index
    @bs_ads = BsAd.active.
      by_category(@category = params[:category]).
      by_ad_type(@ad_type = params[:ad_type]).
      by_time_period(@time_period = params[:time_period]).
      order(@order = params[:order].presence || 'inactive_date desc').
      page(params[:page]).per(100)
  end

  def show
    @bs_ad = BsAd.find(params[:id])

    @activate_date = @bs_ad.created_at
    @deactivate_date = @bs_ad.inactive_date.presence
    @delete_date = @bs_ad.delete_date.presence

    render status: :not_found unless @bs_ad.active?
  end


end

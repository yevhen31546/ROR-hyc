class CrewFinderAdsController < ApplicationController

  resource_controller

  def index
    @crew_finder_ads = CrewFinderAd.active.
      by_ad_type(@ad_type = params[:ad_type]).
      by_time_period(@time_period = params[:time_period]).
      order(@order = params[:order].presence || 'created_at desc').
      page(params[:page]).per(100)
  end

  def show
    @crew_finder_ad = CrewFinderAd.find(params[:id])
  end

  def create
    @crew_finder_ad = CrewFinderAd.new(params[:crew_finder_ad])

    if @crew_finder_ad.save
      flash[:success] = 'Your ad has been created successfully'
      redirect_to :action => :index
    else
      render action: :new
    end
  end
end

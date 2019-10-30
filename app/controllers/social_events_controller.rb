class SocialEventsController < ApplicationController

  def index
    @events = SocialEvent.featured.page(params[:page])
  end

  def show
    @event = SocialEvent.find(params[:id])
  end

end

class WelcomeController < ApplicationController
  def index
    @news_items = NewsItem.actual

    @sidebar_content_page = Page.find_by_code("welcome-sidebar-content")
    if @sidebar_content_page
      @sidebar_content = @sidebar_content_page.content
    end

    @tides_from = Time.now
    @tides_to = Time.now
    @tides = Tide.between(@tides_from, @tides_to)

    @social_events = SocialEvent.featured
    @open_events_today = Event.today + Event.upcoming.limit(6)
    @open_events = Event.featured

    @additional_sidebar_page = Page.find_by_code("welcome-additional-sidebar-content")
    if @additional_sidebar_page
      @additional_sidebar_content = @additional_sidebar_page.content
    end
  end

  def robots
    render :text => settings[:robots]
  end

  def webcam
    render :layout => false
  end
end

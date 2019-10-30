class RacingsController < ApplicationController

  def index
    @months = Date::MONTHNAMES

    @year = Time.now.year
    @filter = params[:filter] || ""
    @month = @months.find_index(params[:month] || "no_month") || Time.now.month

    @racings = {}
    Racing.by_month(@year, @month).by_filter(@filter).each do |v|
      @racings["#{v.event_date.day}/#{@month}/#{@year}"] = v
    end
  end

end

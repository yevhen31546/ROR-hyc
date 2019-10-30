class TidesController < ApplicationController
  layout false

  def index
    from = Date.strptime(params[:from], "%d/%b/%Y") rescue Time.now - 1.day
    to = Date.strptime(params[:to], "%d/%b/%Y") rescue Time.now

    @tides = Tide.between(from, to)
  end
end

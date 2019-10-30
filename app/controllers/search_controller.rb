class SearchController < ApplicationController
  def index
    @results = []
    if ((@query = params[:query]) && @query.present?)
      @results += Page.by_query(@query)
      @results += Testimonial.by_query(@query)
      @results += Resource.by_query(@query)
      @results += NewsItem.by_query(@query)
      @results += BlogPost.by_query(@query)

      @results = Kaminari::PaginatableArray.new(@results).page(params[:page])
    end
  end
end

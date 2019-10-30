class NewsItemsController < ApplicationController
  resource_controller

  index do
    before do
      @news_categories = NewsCategory.non_member
    end
  end

  def show
    @object = @news_item = NewsItem.find(params[:id])
    @news_categories = NewsCategory.non_member
  rescue ActiveRecord::RecordNotFound
    render 'public/404.html', :status => :not_found
  end

private
  def collection
    # raise params.inspect
    @collection = end_of_association_chain
    if params[:news_category_id].present? && @news_category = NewsCategory.find(params[:news_category_id])
      @collection = @collection.where(:news_category_id => params[:news_category_id])
    end
    if params[:str].present?
      @collection = @collection.where('content LIKE :content_str',{:content_str=>"%#{params[:str]}%"})
    end
    if params[:period].present? && params[:period].to_i > 0
      l_period = get_period(params[:period])
      #raise params[:period].inspect#1.week.ago.end_of_week.inspect
      @collection = @collection.where('created_at between :date_start AND :date_end',{:date_start=>"#{l_period.at(0)}",:date_end=>"#{l_period.at(1)}"})
    end
    if params[:only_junior].present?
      @is_junior = true
      @page_name = "Junior Sailing"
      @collection = @collection.where(:is_junior => true)
    end
    if params[:only_cruising].present?
      @is_cruising = true
      @page_name = "Cruising"
      @cruising_category = NewsCategory.find_by_name("Cruising")
      if @cruising_category
        @collection = @collection.where(:news_category_id => @cruising_category.id)
      end
    end
    @collection.page(params[:page]).per(30)
  end

  def get_period(per)
    last_week_begin = 1.week.ago.beginning_of_week.strftime('%Y-%m-%d')
    last_week_end = 1.week.ago.end_of_week.strftime('%Y-%m-%d')
    two_weeks_begin = 2.week.ago.beginning_of_week.strftime('%Y-%m-%d')
    month_begin = 1.month.ago.beginning_of_month.strftime('%Y-%m-%d')
    month_end = 1.month.ago.end_of_month.strftime('%Y-%m-%d')
    defined_periods = ['',[last_week_begin,last_week_end],[two_weeks_begin,last_week_end],[month_begin,month_end]]
    return defined_periods[per.to_i]
  end
end

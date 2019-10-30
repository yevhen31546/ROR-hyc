module Admin::PaginationHelper
  def paginated_section(*args, &block)
    pagination = paginate(*args)
    return 'Nothing here' if args[0].size == 0
    pagination + capture(&block)
  end

  def news_filter
  	period = 0
  	if params[:period].present?
  	  period = params[:period]
  	end
  	%'<div id="news_filter_wrap">
  		<form method="GET" id="">
  			<select name="period">
  			<option value="0" #{period.to_i==0 ? selected="selected" : ""}>All</option>
  			<option value="1" #{period.to_i==1 ? selected="selected" : ""}>Past Week</option>
  			<option value="2" #{period.to_i==2 ? selected="selected" : ""}>Past 2 Weeks</option>
  			<option value="3" #{period.to_i==3 ? selected="selected" : ""}>Past Month</option>
  			</select>
  			<input type="submit" value="Change Period"/>
  			<input type="text" name="str" placeholder="Search this category" value="#{params[:str]}"/>
  			<input type="submit" value="GO"/>
  		</form>
  	</div>'.html_safe
  end
end

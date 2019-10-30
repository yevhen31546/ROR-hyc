module EventsHelper
  def calendar(options={})
    date = (params[:event_month] ? Date.strptime(params[:event_month], '%Y-%m') : Date.today) rescue Date.today  
    @year, @month = date.year, date.month
    @options = options.symbolize_keys.reverse_merge(default_calendar_options)

    @days = Date.civil(@year, @month, 1)..Date.civil(@year, @month, -1)

    %`<table class="#{@options[:calendar_class]}">
        <thead>
          #{show_month_names}
          #{show_day_names}
        </thead>
        <tbody>
          <tr>#{show_previous_month}#{show_current_month}#{show_following_month}</tr>
        </tbody>
      </table>`.html_safe
  end

  private
  def show_previous_month
    return if @days.first.wday == first_day_of_week # don't display anything if the first day is the first day of a week

    output = ""
    beginning_of_week(@days.first).upto(@days.first - 1) { |d| output << show_day(d) }
    output
  end

  def show_current_month
    output = ""
    @days.first.upto(@days.last) { |d| output << show_day(d) }
    output
  end

  def show_following_month
    return if @days.last.wday == last_day_of_week # don't display anything if the last day is the last day of a week

    output = ""
    (@days.last + 1).upto(beginning_of_week(@days.last + 1.week) - 1) { |d| output << show_day(d) }
    output
  end

  def show_day(day)
    options = { :class => "day" }
    options[:class] << " otherMonth" if day.month != @days.first.month
    options[:class] << " weekend" if weekend?(day)
    options[:class] << " today" if day.today?

    events_of_day = Event.where(:date => day.strftime('%Y-%m-%d'))

    if events_of_day.present?
      event_titles = events_of_day.map { |e| e.title}.join(', ')
      options[:class] << " event"
      content = link_to(day.day, events_path(:date => day.strftime('%Y-%m-%d')), :title => event_titles)
    else
      content = day.day
    end

    content_tag(:td, content, options).tap do |output|
      if day < @days.last && day.wday == last_day_of_week # opening and closing tag for the first and last week are included in #show_days
        output << "</tr><tr>".html_safe # close table row at the end of a week and start a new one
      end
    end
  end

  def beginning_of_week(day)
    diff = day.wday - first_day_of_week
    diff += 7 if first_day_of_week > day.wday
    day - diff
  end

  def show_month_names
    return if @options[:hide_month_name]
    events_base_url = request.fullpath.gsub(/[&?]event_month=?[^&?]*/, '')
    prev_month_url = "#{events_base_url}#{(events_base_url =~ /\?/ ? '&' : '?')}event_month=#{(@days.first - 1.month).strftime('%Y-%m')}"
    next_month_url = "#{events_base_url}#{(events_base_url =~ /\?/ ? '&' : '?')}event_month=#{(@days.first + 1.month).strftime('%Y-%m')}"

    %`<tr>
        <th colspan="1">
          #{link_to '<<', prev_month_url, :title => 'Previous month', :class => 'monthLink', :rel => 'nofollow'}
        </th>
        <th colspan="5"><span class='monthName'>#{@days.first.strftime('%B %Y')}</span></th>
        <th colspan="1">
          #{link_to '>>', next_month_url, :title => 'Next month', :class => 'monthLink', :rel => 'nofollow'}
        </th>
      </tr>`
  end

  def show_day_names
    return if @options[:hide_day_names]
    day_names ||= ['S', 'M', 'T', 'W', 'T', 'F', 'S']

    output = '<tr class="day_names">'
    apply_first_day_of_week(day_names).each do |day|
      output << %`<th scope="col">#{day}</th>`
    end
    output << "</tr>"
  end

  def apply_first_day_of_week(day_names)
    names = day_names.dup
    first_day_of_week.times { names.push(names.shift) }
    names
  end

  def first_day_of_week
    @options[:first_day_of_week]
  end

  def last_day_of_week
    @options[:first_day_of_week] > 0 ? @options[:first_day_of_week] - 1 : 6
  end

  def weekend?(day)
    [0,6].include?(day.wday) # 0 = Sunday, 6 = Saturday
  end

  def default_calendar_options
    {
      :calendar_class => "calendar",
      :first_day_of_week => 1,
      :hide_day_names => false,
      :hide_month_name => false,
    }
  end
end

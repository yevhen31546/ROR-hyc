require "uri"
class ResultsController < ApplicationController

  def event_type
    @result = Result.event_types(params[:year])
    render :json => @result
  end

  def event
    @result = Result.events(params[:year], params[:event_type])
    render :json => @result
  end

  def class_name
    @result = Result.class_names(params[:year], params[:event_type], params[:event])
    render :json => @result
  end

  def index
    @years = Result.years
    @event_type = params[:event_type]
    @year = (params[:year].presence || Date.today.year)
    if @year.present? && @event_type.present?
      @result_event_titles = Result.event_titles(@year, @event_type)

      @event_title = params[:event_title]
      @class_name = params[:result_class_name]
      if @event_title.present?
        @results = Result.where(:year => @year, :event_type => @event_type)
        @result_classes = @results.where(:event_title => @event_title)
        if @class_name
          @result = @results.where(:event_title => @event_title, :class_name => @class_name).first
        end
      end
    else
      @events = []
      @result_event_titles = []
      @result_classes = []
    end
  end
  def getold
     url = params[:url]
     response =HTTParty.get(url)
     render text: response.body
  end
  def iframe
    result = Result.find(params[:id])

    unless result.result.exists? || result.ftp_url.present?
      render :text => 'No result file found'
      return
    end

    if result.ftp_url.present?
	    url_to_fetch =result.ftp_url.gsub( "https://hyc","http://old.hyc" )
		url_to_redirect = "/results/getold?url="+URI.encode(url_to_fetch)
	    redirect_to url_to_redirect, status: :found # temporary redirect
    elsif result.result.exists?
      file_html = File.read(result.result.path)
      file_html = file_html.encode Encoding.find('ASCII'), {:invalid => :replace, :undef => :replace, :replace => '', :universal_newline => true}

      venue_logo_url = result.venue_logo.exists? ? result.venue_logo.url : Image.find_by_name("Default Venue Logo").asset.try(:url)
      file_html.gsub!(/<img[^>]*class=["']hardleft["'][^>]*>/, "<img alt='venue image' src='#{venue_logo_url}' class='hardleft'>")
      if result.event_logo.exists?
        event_logo_url = result.event_logo.url
        file_html.gsub!(/<img[^>]*class=["']hardright"[^>]*>/, "<img alt='event image' src='#{event_logo_url}' class='hardright'>")
      else
        file_html.gsub!(/<img[^>]*class=["']hardright"[^>]*>/, "")
      end
      render :inline => file_html
    else
      render :text => 'No result file found'
      return
    end

  end

  def class_options
    @event_title = params[:event_title]
    @result_classes = Result.where(:event_title => @event_title)
    if (@year = params[:year]).present?
      @result_classes = @result_classes.where(:year => @year)
    end
    render :partial => 'results/class_options', :locals => {:result_classes => @result_classes}
  end

  def event_options
    @year = (params[:year].presence || Date.today.year)
    @event_type = params[:event_type].presence

    @result_event_titles = Result.event_titles(@year, @event_type)

    render :partial => 'results/event_options', :locals => {:result_event_titles => @result_event_titles}
  end
end

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Admin::PagesHelper

  def get_site_name
    return settings[:site_name] || 'settings[:site_name] missing'
  end

  def get_title
    "#{"#{@page_name} - " if @page_name}#{get_site_name}"
  end
  
  def get_organisation_name
    settings[:contact_address_org] || 'settings[:contact_address_org] missing'
  end

  def get_description
    @page_description.presence ||
      settings[:site_description].presence ||
      'settings[:site_description] missing'
  end

  def get_keywords
    return settings[:site_keywords].presence
  end

  def current_page_canonical
    if page_class == 'pages catchall'
      return @page.url
    else
      return url_for(:controller => controller_name, :action => action_name)
    end
  end

  def navbar_class_name(target)
    return '' unless target
    target_string_canonical = (target.is_a?(String) ? target : url_for(:controller => target[:controller], :action => target[:action]))
    target_string_canonical == current_page_canonical ? 'current' : nil
  end

  def navbar_link(text, url, options = {})
    target = options[:target]
    return link_to(text, url, {:class => navbar_class_name(url), :target => target})
  end

  def navbar_item_li_class_name(target)
    navbar_class_name(target.link)
  end

  def link_to_current(name, path, options = {})
    link_to name, path, options.merge({:class => (current_page?(path) ? 'current' : nil)})
  end

  # do not print the output of this function
  def insert_flash(flash_name, width, height, class_name = nil)
    flash_path = "/assets/flash/#{flash_name}"
    haml_tag :div, :class => class_name do
      haml_tag :object, :type => 'application/x-shockwave-flash', :data => flash_path, :width => width, :height => height do
        haml_tag :param, :name => 'movie', :value => flash_path
        haml_tag :param, :name => 'wmode', :value => 'opaque'
      end
    end
  end

  def nl2br(str)
    str.gsub("\n", "<br />\n").html_safe
  end
  
  # http://www.napcsweb.com/blog/2007/07/02/using-ruby-blocks-to-make-custom-helpers-in-rails/
  def display_items_from(collection, blank_message="No results found.")
    raise ArgumentError, "You need to provide a block." unless block_given? 
    
    if collection.size > 0
      concat("<p>You have #{collection.size} items.</p>", block.binding)
      
      collection.each do |item|
        yield item
      end
      
    else
      concat(blank_message)
    end 
  end
  
  def controller_stylesheet_link_tag
    controller_stylesheet_path = File.join(Rails.root, 'public', 'stylesheets', controller.controller_name + '.css')
    if File.exists? controller_stylesheet_path
      stylesheet_link_tag controller.controller_name
    end
  end
  
  def admin_content(&block)
    raise ArgumentError, "You need to provide a block." unless block_given?
    with_output_buffer(&block) if is_admin?
  end

  def user_content(&block)
    raise ArgumentError, 'You need to provide a block.' unless block_given?
    with_output_buffer(&block) if logged_in?
  end

  def is_homepage?
    controller_name == 'welcome' && action_name == 'index'
  end

  def homepage(&block)
    raise ArgumentError, 'You need to provide a block.' unless block_given?
    with_output_buffer(&block) if is_homepage?
  end

  def interpolate_content(content)
    gallery_regex = /\[gallery &quot;(.*)&quot;\]/
    if match = (content.match(gallery_regex))
      gallery_name = match[1]
      if gallery_name
        gallery = GalleryAlbum.find_by_title(gallery_name)
        if gallery.present?
          @gallery_album = gallery
          @gallery_photos = @gallery_album.gallery_photos
          gallery_html = render(:partial => 'gallery_photos/index')
          content.gsub!(gallery_regex, gallery_html)
        end
      end
    end
    return content.html_safe
  end

  # truncate the content to a certain length or just show up to the more tag
  def read_more(content, options = {})
    options = {:length => 400}.merge(options)
    more_tag = "<!--more-->"
    if cutoff_index = (content.html_safe.index(more_tag))
      content.html_safe[0,cutoff_index]
    else
      truncate_html content.html_safe, :length => options[:length]
    end
  end

  def post_metadata(blog_post)
    md_arr = []
    if blog_post.blog_category.present?
      md_arr << "in <span class='category' itemprop='keywords'>#{blog_post.blog_category.name}</span> "
    end
    if blog_post.author.present?
      md_arr << "by <span class='author' itemprop='author'>#{blog_post.author}</span> "
    end
    md_arr.present? ? "Posted #{md_arr.join(' ')} | ".html_safe : ''
  end

  def link_to_add_fields(name, f, association, partial)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    partial ||= association.to_s.singularize + "_fields"
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(partial, f: builder)
    end
    link_to(name, '#', class: "add_fields inline_add_icon", data: {id: id, fields: fields.gsub("\n", "")})
  end

  # joins a bunch of dates together in a string
  # e.g. 2nd of May 2012 and 12th of May 2013
  # 1st, 2nd, 3rd of May and 12th and 13th of June 2012
  def display_multiple_dates(*dates)
    dates_in_year = dates.sort.compact.group_by(&:year)
    dates_in_year.collect do |year, dates_for_year|
      dates_by_month = dates_for_year.compact.group_by(&:month)
      str = dates_by_month.collect do |month, dates_in_month|
        s = dates_in_month.collect {|date| date.strftime("%d").to_i.ordinalize }.to_sentence(:last_word_connector => " and ")
        s << " of #{dates_in_month.first.strftime("%b")}"
      end.flatten.join(" and ")
      str << " #{dates_by_month.values.flatten.first.strftime("%Y")}"
      str
    end.flatten.join(" and ")
  end

  def er_style_classes(event_resource_or_style)
    if event_resource_or_style.is_a?(EventResource)
      style = event_resource_or_style.button_style
    elsif event_resource_or_style.is_a?(String)
      style = event_resource_or_style
    end
    
    if style.present?
      style = style.gsub(/_/, '-')
      "event-resources-button-style event-resources-button-style-#{style}"
    end
  end
end

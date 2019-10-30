module Admin::PagesHelper
  def page_content(code)
    find_page(code).content.html_safe
  end

  def page_title(code)
    find_page(code).title
  end

  def page_url(code)
    find_page(code).url
  end

  def page_seo_title(code)
    find_page(code).seo_title_with_fallback
  end

  def page_seo_description(code)
    find_page(code).seo_description_with_fallback
  end

  def page_extended_title(code)
    find_page(code).extended_title_with_fallback
  end

  def magick_asset(asset)
    Magick::Image.read(asset.asset.path(:custom)).first rescue nil
  end

  private

  def find_page(code)
    begin
      raise "No code given" unless code.present?
      (code.is_a?(Page) ? code : Page.find_by_code(code))
    # rescue
    #   Rails.logger.debug $!.to_s
    #   "No page exists for #{code}"
    end
  end
end

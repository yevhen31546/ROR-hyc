class PagesController < ApplicationController
  def catchall
    @page = Page.find_by_url(request.path) or raise ActionController::RoutingError, "No route matches #{request.path.inspect} with {:method=>#{request.method.inspect}}"
    render :template => 'admin/pages/show', :layout => @page.layout_for_render
  end
  def reroute_images
	  render text: request.path

  end
end

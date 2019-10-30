class GalleryCategoriesController < ApplicationController
  resource_controller

  def index
    @gallery_categories = GalleryCategory.top_level.order('name desc').page(params[:page])
  end

  def show
    @gallery_category = GalleryCategory.find(params[:gallery_category_id])
    @gallery_categories = @gallery_category.children
  end

end

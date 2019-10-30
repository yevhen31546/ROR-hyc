class Admin::GalleryCategoriesController < Admin::BaseController
  resource_controller

  def show
    load_object
    redirect_to admin_gallery_categories_path
  end

  def index
    @gallery_categories = GalleryCategory.top_level.page(params[:page]).order('name desc').per(100)
  end
end

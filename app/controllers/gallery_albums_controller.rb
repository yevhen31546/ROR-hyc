class GalleryAlbumsController < ApplicationController

  def index
    order = 'name desc'
    if params[:gallery_category_id].present?
      @gallery_category = GalleryCategory.find(params[:gallery_category_id])
      order = 'gallery_albums.position asc'
    end
    @gallery_albums = @gallery_category.gallery_albums.page(params[:page]).reorder(order)
  end
end

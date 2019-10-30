class GalleryPhotosController < ApplicationController
  resource_controller

  def index
    load_collection
    unless params[:gallery_album_id].blank?
      @gallery_album = GalleryAlbum.find(params[:gallery_album_id])
    end
    unless params[:gallery_category_id].blank?
      @gallery_category = GalleryCategory.find(params[:gallery_category_id])
    end

  rescue ActiveRecord::RecordNotFound
    render 'public/404.html', :status => :not_found
  end

  def search
    @query = params[:query]
    if params[:gallery_category_id].present?
      @gallery_category = GalleryCategory.find(params[:gallery_category_id])
    end

    if params[:gallery_album_id].present?
      @gallery_album = GalleryAlbum.find(params[:gallery_album_id])
    end

    @gallery_photos = GalleryPhoto.
      by_gallery_album(@gallery_album).
      by_gallery_category(@gallery_category).
      by_query(@query).page(params[:page])
  end

private
  def collection
    if params[:gallery_album_id].blank?
      coll = end_of_association_chain.page(params[:page])
    else
      coll = end_of_association_chain.where(:gallery_album_id => params[:gallery_album_id]).page(params[:page])
    end

    if (@filter = params[:filter]).present?
      coll = coll.where(:filter => @filter)
    end

    coll = coll.reorder('sort asc, created_at asc')

    coll
  end
end

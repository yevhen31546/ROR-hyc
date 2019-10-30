class Admin::GalleryAlbumsController < Admin::BaseController
  resource_controller

  def show
    load_object
    redirect_to admin_gallery_album_gallery_photos_path(@gallery_album)
  end

  def update_all
    if params[:gallery_albums].present?
      params[:gallery_albums].each do |gallery_album_id, updates|
        @gallery_album = GalleryAlbum.find(gallery_album_id)
        @gallery_album.update_attributes(updates)
      end
      redirect_back_or_default :action => :index
    else
      redirect_back_or_default :action => :index
    end
  end

  private
  def collection
    @coll = end_of_association_chain.includes(:gallery_category).page(params[:page])

    if params[:gallery_category_id].present?
      @selected_gallery_category_id = params[:gallery_category_id]
      cats = [@selected_gallery_category_id, GalleryCategory.find(@selected_gallery_category_id).descendants.map(&:id)].flatten
      @coll = @coll.where('gallery_category_id' => cats).reorder('gallery_albums.position asc')
    end

    end_of_association_chain = @coll
  end
end 

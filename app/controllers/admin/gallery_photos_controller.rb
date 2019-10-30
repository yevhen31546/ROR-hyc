class Admin::GalleryPhotosController < Admin::BaseController
  resource_controller
  belongs_to :gallery_album

  def show
    redirect_to :action => 'index'
  end

  def use_as_cover
    load_object
    @gallery_album.update_attributes!(:cover_photo_id => @gallery_photo.id)
    flash[:success] = "Cover image for album has been updated"
    smart_redirect
  end

  def index
    @gallery_album = GalleryAlbum.find(params[:gallery_album_id])
    @gallery_photos = collection
    if request.xhr?
      render :partial => 'photo', :collection => @gallery_photos, :layout => false, :as => :gallery_photo
    end
  end

  update.wants.html { smart_redirect }
  create.wants.html { smart_redirect }

  def upload
    photo = GalleryPhoto.new(
      :photo => params[:file],
      :filter => params[:filter],
      :gallery_album_id => params[:gallery_album_id])
    photo.caption = photo.photo.original_filename
    if photo.save
      head :ok
    else
      head 500
    end
  end

  def multiple
    # we're going to make some changes to specific photos (not all the same changes)
    if params[:photos].present?
      params[:photos].each do |photo_details|
        photo_id, attrs = *photo_details
        GalleryPhoto.find(photo_id).update_attributes(attrs)
      end
    end

    # we're going to mass change all photos to the same value
    if params[:ids].present?
      new_values = {}
      if params[:filter].present?
        new_values[:filter] = params[:filter]
      end
      if new_values.present?
        GalleryPhoto.where(id: params[:ids]).update_all(new_values)
      end
    end

    redirect_to :action => :index
  end

  private
  def collection
    coll = end_of_association_chain.page(params[:page])
    if params[:gallery_album_id].present?
      coll.where(:gallery_album_id => params[:gallery_album_id])
    end

    if params[:filter_list].present?
      coll = coll.where('filter' => params[:filter_list])
    end

    coll = coll.reorder('sort asc, created_at asc')

    coll
  end

  def smart_redirect
    if params[:gallery_album_id].blank?
      redirect_to :action => 'index'
    else
      redirect_to admin_gallery_album_gallery_photos_path(@gallery_album)
    end
  end
end

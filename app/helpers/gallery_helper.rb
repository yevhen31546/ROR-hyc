module GalleryHelper

  def sanitize_gallery_thumb(asset, asset_alt)
    if asset.nil? || !asset.photo.exists?
      thumb_img = image_tag('admin/missing_icon.png', :alt => 'missing')
    elsif asset.photo.original_filename.match(/(\.gif|\.png|\.jpe?g)$/i)
      thumb_img = image_tag(asset.photo.url(:medium), :alt => asset_alt)
    else
      thumb_img = image_tag('admin/unknown_icon.png', :alt => 'not available')
    end
    thumb_img
  end

end
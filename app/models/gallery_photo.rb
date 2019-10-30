class GalleryPhoto < ActiveRecord::Base
  default_scope :order => 'created_at desc'

  IMAGE_CONTENT_TYPES = ['image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/pjpeg', 'image/x-png']
  has_attached_file :photo, :styles => {:thumb => '144x80#', :medium => '160x160#', :full => '960x540>'}
  validates_attachment_content_type :photo, :content_type => IMAGE_CONTENT_TYPES
  validates_attachment_presence :photo

  belongs_to :gallery_album

  @@searchable_fields = ["gallery_photos.caption", "gallery_photos.photo_file_name"]
  include SimpleTextSearchable

  class << self
    def by_gallery_album(gallery_album)
      gallery_album.present? ? where(gallery_album_id: gallery_album) : scoped
    end

    def by_gallery_category(gallery_category)
      if gallery_category
        gallery_albums = gallery_category.gallery_albums_including_children
        gallery_albums.present? ? by_gallery_album(gallery_albums) : scoped
      else
        scoped
      end
    end

    def available_filters
      return ['Prize Giving', 'Event']
    end
  end
end

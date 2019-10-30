class GalleryAlbum < ActiveRecord::Base
  default_scope :order => 'created_at desc'

  belongs_to :cover_photo, :class_name => 'GalleryPhoto'
  belongs_to :gallery_category

  has_many :gallery_photos
  validates :title, :presence => true

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def filters
    gallery_photos.where('filter != "" && filter IS NOT NULL').select('distinct(filter)').map(&:filter)
  end
end

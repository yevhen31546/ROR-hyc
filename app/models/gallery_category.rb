class GalleryCategory < ActiveRecord::Base
  acts_as_tree
  scope :top_level, :conditions => {:parent_id => nil}

  has_many :gallery_albums

  validates :name, :presence => true

  class << self
    def all_except(obj)
      obj && !obj.new_record? ? where("id != ?", obj.id) : scoped
    end
  end

  def gallery_albums_including_children
    [self, self.descendants].flatten.map(&:gallery_albums).flatten.compact
  end

  def name_with_ancestors
    [self.ancestors, self].flatten.map(&:name).join(" &rarr; ").html_safe
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def cover_photo
    gallery_albums.order('created_at desc').first.try(:cover_photo)
  end
end

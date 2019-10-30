class Image < Asset
  attr_accessor :layout

  default_scope :order => 'created_at desc'

  IMAGE_CONTENT_TYPES = ['image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/pjpeg', 'image/x-png', 'image/tiff']
  has_attached_file :asset, :styles => {:thumb => '144x80>',
    :custom => Proc.new { |instance| instance.calculate_custom_geometry }},
    :url => "/system/files/:id/:style/:filename"
  validates_attachment_content_type :asset, :content_type => IMAGE_CONTENT_TYPES

  before_update :reprocess_if_dimensions_changed
  after_create :reprocess_if_necessary
  after_update :reprocess_if_necessary

  def reprocess_if_dimensions_changed
    self.asset.reprocess! if self.width_changed? || self.height_changed?
  end

  def reprocess_if_necessary
    self.asset.reprocess! unless File.exist?(asset.path(:thumb))
  end

  def calculate_custom_geometry
    geometry = "#{self.width.to_s}"
    geometry << "x#{self.height.to_s}>" if self.height.present?
    geometry = '100%' if geometry.blank?
    geometry
  end

  @@searchable_fields = ["assets.name", "assets.category", "assets.asset_file_name"]
  include SimpleTextSearchable
end

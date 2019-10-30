class Asset < ActiveRecord::Base
  # putting in whiny => false makes it able to process non-image files without
  # complaining that it can't create thumbnails 
  has_attached_file :asset
  validates_attachment_size :asset, :less_than => 8.megabytes, :if => lambda {|inst| inst.asset.exists? }
  validates_attachment_presence :asset
  before_save :set_asset_name 
  validates :name, :presence => true

  def set_asset_name
    return if asset_file_name.nil?
    if asset_file_name_changed?
      self.asset.instance_write(:file_name, normalized_asset_file_name)
    end
  end 

  def normalized_asset_file_name
    "#{self.name.parameterize}#{File.extname(self.asset_file_name).downcase}" 
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end

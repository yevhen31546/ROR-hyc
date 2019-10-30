class Resource < Asset
  attr_accessor :layout

  default_scope :order => 'created_at desc'

  has_attached_file :asset, :styles => {},
    :url => "/system/files/:id/:style/:filename"
  
  def is_pdf?
    self.file_content_type == 'application/pdf'
  end

  @@searchable_fields = ["assets.name"]
  include SimpleTextSearchable
end

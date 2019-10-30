class BlogPost < ActiveRecord::Base
  default_scope :order => 'created_at desc'
  has_many :blog_comments
  belongs_to :blog_category
  validates :title, :content, :presence => true

  before_save :image_destroy
  attr_accessor :image_delete 
  has_attached_file :image, :styles => {:thumb => '144x80#', :normal => '288x160>'}
  validates_attachment_size :image, :less_than => 8.megabytes, :if => lambda {|inst| inst.image.exists? }
  def image_destroy
    self.image.destroy if self.image_delete=='1' && !self.image.dirty? 
  end

  @@searchable_fields = ["blog_posts.title", "blog_posts.content", "blog_posts.author"]
  include SimpleTextSearchable
  
  def to_param
    "#{id}-#{title.parameterize}"
  end
end

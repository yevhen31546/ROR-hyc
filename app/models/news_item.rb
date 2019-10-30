class NewsItem < ActiveRecord::Base
  default_scope :order => 'created_at desc'

  belongs_to :news_category

  validates :title, :content, :presence => true

  @@searchable_fields = ["news_items.title", "news_items.content"]
  include SimpleTextSearchable

  before_save :image_destroy
  attr_accessor :image_delete
  has_attached_file :image, :styles => {:thumb => '144x80#', :normal => '400x400>'}
  validates_attachment_size :image, :less_than => 8.megabytes, :if => lambda {|inst| inst.image.exists? }

  def self.actual
    where("featured = 1 AND publish_at < ?", Time.now).
    order("CASE WHEN ordering IS NULL THEN 1000 ELSE ordering END, publish_at desc, created_at desc")
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def image_destroy
    self.image.destroy if self.image_delete=='1' && !self.image.dirty?
  end

  def is_cruising?
    news_category && news_category.name =~ /Cruising/
  end
end

class Video < ActiveRecord::Base
  default_scope :order => 'created_at desc'

  validates :title, :presence => true
  validates :url, :presence => true

  def to_param
    "#{id}-#{title.parameterize}"
  end
end
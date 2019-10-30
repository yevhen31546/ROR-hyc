class BlogCategory < ActiveRecord::Base
  has_many :blog_posts, :dependent => :nullify

  validates_presence_of :name

  def to_param
    "#{id}-#{name.parameterize}"
  end
end

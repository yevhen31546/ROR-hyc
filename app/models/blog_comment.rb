class BlogComment < ActiveRecord::Base
  default_scope :order => 'created_at desc'
  scope :approved, :conditions => {:status => 'approved'}
  scope :unapproved, :conditions => {:status => 'unapproved'}

  belongs_to :blog_post

  validates_presence_of :author, :comment, :status, :ip
  validates_associated :blog_post
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_blank => true
  validates_format_of :comment, :with => /$^/, :if => Proc.new { |x| x.comment =~ /\[link=|\[url=/ }, :message => 'appears like spam'

  attr_protected :status, :ip

  def date
    created_at.strftime('Posted at: %H:%M, %a %d %b %Y')
  end

  def approved?
    status == 'approved'
  end

  def unapproved?
    status == 'unapproved'
  end
end

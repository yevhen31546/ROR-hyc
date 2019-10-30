class TeamMember < ActiveRecord::Base
  default_scope :order => 'sort asc'

  validates :name, :presence => true
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :if => Proc.new { |x| x.email.present? }


  before_save :photo_destroy
  attr_accessor :photo_delete 
  has_attached_file :photo, :styles => {:thumb => '80x80#', :normal => '200x200>'}
  validates_attachment_size :photo, :less_than => 8.megabytes, :if => lambda {|inst| inst.photo.exists? }
  def photo_destroy
    self.photo.destroy if self.photo_delete=='1' && !self.photo.dirty? 
  end

  def obfuscated_email
    email.gsub(/@/, ' at ').gsub(/\./, ' dot ')
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end
end

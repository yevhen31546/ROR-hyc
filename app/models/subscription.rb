class Subscription < ActiveRecord::Base
  include SpamProtection

  validates :email, :first_name, :last_name, :presence => true
  validates_uniqueness_of :email, :case_sensitive => false, :message => 'This email is already subscribed to newsletter'
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :if => Proc.new { |x| x.email.present? }

  attr_accessor :name

  before_validation :set_name

  private
  def set_name
    if self.name.present?
      self.first_name, *self.last_name = name.split
      self.last_name = self.last_name.join(' ')
    end
  end
end

class FeedItem < ActiveRecord::Base
  belongs_to :feed

  default_scope :order => 'published_at desc'

  def before_validation
    self.published_at = Time.now if self.published_at.blank?
  end  
 
  validates :entry_id, :uniqueness => true
end

class SocialEvent < ActiveRecord::Base
  default_scope :order => "date asc"

  scope :featured, where("featured is true")

end

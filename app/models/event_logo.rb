class EventLogo < ActiveRecord::Base
  belongs_to :event

  has_attached_file :image,
    :styles => {:thumb => '100x80>', :small => "140>", :normal => '266>'},
    :path => ":rails_root/public/system/event_logo_images/:id/:style/:filename",
    :url => "/system/event_logo_images/:id/:style/:filename"
end

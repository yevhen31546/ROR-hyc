class Contact < ActiveRecord::Base
  validates :name, :presence => true
  validates :email, :email => true

  has_attached_file :photo, :styles => {:thumb => '64x64#', :small => '82x82#', :medium => '128x128#', :full => '360x360>'}

  CATEGORIES = ['club office', 'flag officers', 'officers', 'general committee', 'sailing sub-committee chairmen', 'class captains']

  FLAGS = {
    'commodore' => 'commodore',
    'vicecommodore' => 'vice-commodore',
    'rearcommodore' => 'rear-commodore',
    'exofficio' => 'ex-commodore',
    'excommodore' => 'ex-commodore',
  }

  default_scope :order => "sort_order"
end

class AdminModule < ActiveRecord::Base
  default_scope :order => 'sort, name'
  scope :active, :conditions => {:active => true}
  scope :superadmin_active, :conditions => {:superadmin_active => true}

  has_many :children, :foreign_key => 'parent_id', :class_name => 'AdminModule'
  belongs_to :parent, :class_name => 'AdminModule'
end

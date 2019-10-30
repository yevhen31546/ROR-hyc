class Navbar < ActiveRecord::Base
  has_many :navbar_items
  has_many :top_level_navbar_items, :conditions => "parent_id IS NULL", :class_name => "NavbarItem"

  def to_jstree_json
    self.navbar_items.map(&:to_jstree_json)
  end
end

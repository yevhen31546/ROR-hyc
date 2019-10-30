class Role < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  def self.non_admins
    where("name NOT IN ('admin', 'superadmin')")
  end
end

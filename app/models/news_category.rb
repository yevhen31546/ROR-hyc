class NewsCategory < ActiveRecord::Base
  has_many :news_items

  def to_param
    "#{id}-#{name.parameterize}"
  end

  class << self
    def non_member
      where("name != ?", "Members")
    end
  end
end

class NavbarItem < ActiveRecord::Base
  belongs_to :navbar
  default_scope :order => 'position asc'
  acts_as_tree :order => "position"
  belongs_to :page
  belongs_to :asset
  scope :top_level, :conditions => {:parent_id => nil}
  TARGETS = [["_blank - New Window", "_blank"], "_parent", "_self", "_top"]

  validates :name, :presence => true

  def link
    return url if url.present?
    return page.url if page
    return asset.asset.url(:original) if asset
    if self.controller.present? or self.action.present?
      return {:controller => self.controller,
        :action => (self.action.present? ? self.action : 'index')}.
          merge(Rack::Utils.parse_query(self.parameters || ""))
    end
  end

  def to_jstree_json
    hsh = {
      :attributes => {:id => "node_#{self.id}"},
      :data => self.name
    }
    if !self.children.empty?
      hsh[:children] = self.children.map { |ni| ni.to_jstree_json }
    end
    hsh.to_json
  end

  attr_accessor :should_create_page
  before_create :create_page

  private
  def create_page
    if ActiveRecord::ConnectionAdapters::Column.value_to_boolean(self.should_create_page) == true &&
        self.valid?
      if new_page = Page.create(:title => self.name, :url => '/'+self.name.parameterize,
        :code => self.name.parameterize)
        self.page = new_page
      end
    end
  end
end

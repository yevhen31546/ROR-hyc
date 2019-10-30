class Page < ActiveRecord::Base
  include Admin::ResourceRoleHelper
  has_many :roles, :through => :role_resource_access
  has_many :role_resource_access, :as => :object, :class_name => "RoleResourceAccess"

  validates :title, :presence => true, :uniqueness => true
  validates :url, :uniqueness => true, :format => {:with => /^\/[-_a-z0-9\/]*$/i}, :if => Proc.new { |x| x.url.present? }
  validates :code, :uniqueness => true, :if => Proc.new { |x| x.code.present? }

  BLACKLISTED_LAYOUTS = ['admin']
  DEFAULT_LAYOUT = 'application'
  default_value_for :layout, DEFAULT_LAYOUT

  @@searchable_fields = ["pages.title", "pages.content"]
  include SimpleTextSearchable

  attr_accessor :add_to_main_navbar
  after_create :add_page_to_main_navbar

  def add_page_to_main_navbar
    if ActiveRecord::ConnectionAdapters::Column.value_to_boolean(self.add_to_main_navbar) == true
      Navbar.find(:first).navbar_items.create(:name => self.title, :page_id => self.id)
    end
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def seo_title_with_fallback
    [self.seo_title, self.title].detect(&:present?)
  end

  def seo_description_with_fallback
    [self.seo_description,
      (self.seo_title_with_fallback + " - " + settings[:site_description].to_s)].
      detect(&:present?).html_safe
  end

  def extended_title_with_fallback
    [self.extended_title, self.title].detect(&:present?)
  end

  def layout_for_render
    if layout == 'no layout'
      return false
    elsif layout.present?
      return layout
    else layout.nil?
      return DEFAULT_LAYOUT
    end
  end
end

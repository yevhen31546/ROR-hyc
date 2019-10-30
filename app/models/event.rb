#Codereview
class Event < ActiveRecord::Base
  STATUSES = ['upcoming', 'open', 'closed', 'cancelled']
  # EVENT_TYPES = ['open', 'club', 'social']
  EVENT_TYPES = ['open', 'club', 'social', 'training']

  validates :title, :date, :event_type, :presence => true
  # validates :total_number_of_entries, :presence => true, numericality: { only_integer: true }
  validates :event_type, :inclusion => EVENT_TYPES

  has_attached_file :event_logo, :styles => {:thumb => '100x80>', :normal => '266>'}
  has_attached_file :sponsor_logo, :styles => {:thumb => '100x80>', :normal => '266>'}
  has_attached_file :featured_logo, :styles => {:thumb => '100x80>', :normal => '240>'}
  has_many :event_logos, :dependent => :destroy
  accepts_nested_attributes_for :event_logos, :allow_destroy => true


  has_many :event_resources
  has_one :entry_form, :dependent => :destroy
  delegate :entries, :to => :entry_form
  has_many :event_dates
  has_many :entry_lists
  has_one :event_dinner, :dependent => :destroy

  belongs_to :gallery_album
  #accepts_nested_attributes_for :resources, :allow_destroy => true

  accepts_nested_attributes_for :event_dates, :allow_destroy => true

  scope :today, where("DATE(date) = CURDATE()")

  default_value_for :featured_position do
    (scoped.maximum(:featured_position) || 0) + 1
  end

  # this is just a convenience method that joins the start date in the event model
  # with the attached event dates
  def dates
    ([date] + event_dates.pluck(:date)).compact.sort
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def title_with_sub
    (title + '<br/>' + sub_title.to_s).html_safe
  end

  def detailed_name
    "#{title} - #{sub_title} [#{self.date.year}, #{self.event_type}]"
  end

  def title_with_year
    "#{title} (#{self.date.year})"
  end

  # def capacity_check?
  #   (total_number_of_entries.present? && )
  # end

  # def entries_count

  # end

  def enterable?
    ( (online_entry_show_date.blank? && entry_form) || (online_entry_show_date.present? && online_entry_show_date <= Date.today) ) &&
    (  online_entry_hide_date.blank?                || (online_entry_hide_date.present? && online_entry_hide_date >  Date.today) )
  end

  def show_entry_list?
    ( (entry_list_show_date.blank? && enterable?) || (entry_list_show_date.present? && entry_list_show_date <= Date.today) ) &&
    (  entry_list_hide_date.blank?                || (entry_list_hide_date.present? && entry_list_hide_date >  Date.today) )
  end

  class << self
    def by_year(year)
      year.present? ? where("YEAR(date) = ?", year) : scoped
    end

    def by_event_type(event_type)
      event_type.present? ? where(:event_type => event_type) : scoped
    end

    def years
      select('distinct(YEAR(date)) as year').map(&:year)
    end

    def current_and_upcoming_years
      select('distinct(YEAR(date)) as year').where("YEAR(date) > ?", Date.year).map(&:year)
    end

    def upcoming
      where("date > ?", Date.today).order("date asc")
    end

    def featured
      where(:is_featured => true).order('featured_position asc')
    end

    def show_results
      where(:show_results => true)
    end
  end
end

class Result < ActiveRecord::Base
  default_scope { order('position, id') }

  validates :event_title, :presence => true

  has_attached_file :result

  has_attached_file :event_logo
  before_save :event_logo_destroy
  attr_accessor :event_logo_delete
  validates_attachment_size :event_logo, :less_than => 8.megabytes, :if => lambda {|inst| inst.event_logo.exists? }
  def event_logo_destroy
    self.event_logo.destroy if self.event_logo_delete=='1' && !self.event_logo.dirty?
  end

  has_attached_file :venue_logo
  before_save :venue_logo_destroy
  attr_accessor :venue_logo_delete
  validates_attachment_size :venue_logo, :less_than => 8.megabytes, :if => lambda {|inst| inst.venue_logo.exists? }
  def venue_logo_destroy
    self.venue_logo.destroy if self.venue_logo_delete=='1' && !self.venue_logo.dirty?
  end

  def self.event_titles(year, event_type)
    where(:year => year, :event_type => event_type).group(:event_title).order_by_event_position
  end

  def self.years
    select("year").group("year").reorder('year desc').map(&:year)
  end

  def self.event_types(year)
    select("event_type").
    where("year = ?", year).
    group("event_type")
  end

  def self.class_names(year, event_type)
    select("class_name").
    where("year = ? and event_type = ?", year, event_type).
    group("class_name")
  end

  def self.order_by_event_position
    reorder('IF(event_position IS NULL, 10000000, event_position) asc')
  end

  # how many events per result
  def self.num_for_event_title(event_title)
    where(event_title: event_title).count
  end

  def ftp_url
    if ftp_path.present?
      # this will proxy to the real FTP site
      "https://hyc.ie" + ftp_path
    end
  end
end

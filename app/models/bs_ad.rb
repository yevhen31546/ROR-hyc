class BsAd < ActiveRecord::Base
  include SpamProtection

  before_create :calculate_dates

  paginates_per 100

  AD_TYPES = ['for sale', 'wanted']
  CURRENCIES = ["Euro", "Sterling"]
  CURRENCY_UNITS = {"Euro" => "&euro;", "Sterling" => '&pound;'}
  CATEGORIES = ['Cruiser', 'Dinghy', 'Keelboat', 'Other']
  STATUSES = ['active', 'inactive'] # 'approved', 'rejected'

  has_attached_file :photo, :styles => {:thumb => '144x80>', :medium => '160x160>', :full => '960x540>'}
  has_attached_file :doc, :less_than => 3.megabytes

  validates :name, :ad_type, :category, :location, :contact_name, :status, :presence => true
  validates :ad_type, :inclusion => AD_TYPES
  validates :category, :inclusion => CATEGORIES
  validates :status, :inclusion => STATUSES
  validates :currency, :inclusion => CURRENCIES
  validates :price, :numericality => true
  validate :contact_email, :email => true, :unless => lambda { |x| x.contact_phone.present? }
  validate :contact_phone, :unless => lambda { |x| x.contact_email.present? }
  validates_format_of :doc_content_type, :if => lambda { |x| x.doc.present? }, :with => /application\/.*word.*/, :message => "must be word document"

  # virtual attribute so that you can advise the model to update it's status to this new status
  attr_accessor :new_status

  before_validation do |ad|
    if ad.status.nil?
      ad.status = "active"
    end
    if ad.new_status.present?
      handle_status_change
    end
  end

  class << self
    def active
      where("inactive_date IS NULL OR inactive_date > CURDATE()").
        where("status != 'inactive'").
        not_deleted
    end

    def not_deleted
      where("delete_date IS NULL OR delete_date > CURDATE()")
    end

    def by_time_period(time_period)
      time_period_obj =
        case time_period
        when "All Past"
          10.year.ago # you could also use 2.month.ago
        when "Past Week"
          1.week.ago
        when "Past 2 Weeks"
          2.weeks.ago
        when "Past Month"
          1.month.ago
        else
          10.year.ago # you could also use 2.month.ago
        end
      where("created_at > ?", time_period_obj)
    end

    def by_category(category)
      if category.present? && CATEGORIES.include?(category)
        where(:category => category)
      else
        scoped
      end
    end

    def by_ad_type(ad_type)
      if ad_type.present? && AD_TYPES.include?(ad_type)
        where(:ad_type => ad_type)
      else
        scoped
      end
    end
  end

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  # set the dates for making an ad inactive or to delete it
  def calculate_dates
    self.inactive_date = Time.now + 2.months
    self.delete_date = Time.now + 4.months
  end


  def currency_unit
    CURRENCY_UNITS[currency] || CURRENCY_UNITS.values.first
  end

  def approved?
    status == 'approved'
  end

  def rejected?
    status == 'rejected'
  end

  # def approve!
  #   self.update_attribute(:status, "approved")
  # end

  # def reject!
  #   self.update_attribute(:status, "rejected")
  # end

  #add new functionality to eventually replace approve/reject with active/inactive
  #duplicating for now to allow for existing ads

  def active?
    self.inactive_date && Time.now < self.inactive_date
  end

  def inactive?
    !self.inactive_date || Time.now >= self.inactive_date
  end

  # if the user changed the status, reset the inactive, deletion dates
  def handle_status_change
    return nil unless self.new_status.present?
    self.status = self.new_status
    if self.new_status == 'active'
      # the user wants to make the ad active now so push out the inactive and deletion dates
      self.inactive_date = Time.now + 2.months
      self.delete_date = Time.now + 4.months
    elsif self.new_status == 'inactive'
      # the user wants to make the ad inactive now so make the inactive date to day and deletion in 2 months
      self.inactive_date = Time.now
      self.delete_date = Time.now + 2.months
    end
  end

  def activate!
    self.update_attribute(:status, "active")
  end

  def deactivate!
    self.update_attribute(:status, "inactive")
  end
end

class CrewFinderAd < ActiveRecord::Base
  include SpamProtection

  AD_TYPES = ['available', 'wanted']
  AGE_GROUPS = ['<18', '19-25', '26-40', '40+']
  INTERESTED_IN_OPTIONS = ['Dinghies', 'Cruising', 'Inshore/Local Racing', 'Offshore/Coastal']
  AVAILABILITY_OPTIONS = ['Tuesday Evenings', 'Wednesday Evenings', 'Saturdays', 'Sundays', 'Any Midweek']
  POSITIONS = ['Any ', 'Helm', 'Trimmer', 'Bow', 'Tactician', 'Pit', 'Don\'t know what these mean!', 'Any crew position']
  SAILIING_EXPERIENCE_OPTIONS = ['I sail regularly', 'Completed junior courses', 'Completed adult courses', 'New to sailing', 'Some experience']

  validates :ad_type, :contact_name, :contact_email, :contact_phone, :presence => true
  validates :ad_type, :inclusion => AD_TYPES
  validates :age, :interested_in, :availability, :preferred_position, :experience, :presence => true, :if => lambda { |o| o.ad_type == 'available' }
  validates :description, :presence => true, :if => lambda { |o| o.ad_type == 'wanted' }

  def interested_in_arr=(interests)
    if interests.is_a?(Array)
      converted = interests.reject{|i|i.blank?}.sort.join(',')
    else
      converted = interests
    end
    self.interested_in = converted
  end

  def interested_in_arr
    self.interested_in.try(:split, ',')
  end

  def availability_arr=(availability_selection)
    if availability_selection.is_a?(Array)
      converted = availability_selection.reject{|i|i.blank?}.sort.join(',')
    else
      converted = availability_selection
    end
    self.availability = converted
  end

  def availability_arr
    self.availability.try(:split, ',')
  end


  class << self
    def active
      scoped
    end

    def by_time_period(time_period)
      time_period_obj =
        case time_period
        when "All Past"
          20.years.ago
        when "Past Week"
          1.week.ago
        when "Past 2 Weeks"
          2.weeks.ago
        when "Past Month"
          1.month.ago
        else
          20.years.ago
        end
      where("created_at > ?", time_period_obj)
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
    "#{self.id}-#{self.contact_name.parameterize}"
  end
end

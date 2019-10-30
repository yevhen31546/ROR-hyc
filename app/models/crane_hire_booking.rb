class CraneHireBooking < ActiveRecord::Base
  validates :owner_name, :mobile,
    :boat_name, :boat_type, :loa, :crane_size,
    :crane_hire_primary_start_at_date,
    :crane_hire_primary_start_at,
    :crane_in_out,
    :presence => true
  validates :email, :email => true, :presence => true

  validates :is_member, inclusion: { in: [true, false] }

  validates :crane_hire_primary_start_at_time, :presence => true, :on => :create, :if => lambda { |b| b.requested_cradle_days.to_i == 0 }

  attr_accessor :crane_hire_primary_start_at_date, :crane_hire_primary_start_at_time

  belongs_to :crane_hire_price

  before_validation :set_crane_hire_times, :set_cradle_hire_times

  validate :ensure_no_conflict

  before_create :set_charge

  default_value_for :requested_cradle_days, 0

  belongs_to :payment_item, :dependent => :destroy
  PAYMENT_STATUSES = ['unpaid', 'paid']
  default_value_for :payment_status, 0

  def self.paid
    where(payment_status: PAYMENT_STATUSES.index('paid'))
  end

  def self.paid_or_admin
    where("payment_status = ? OR is_admin = 1", PAYMENT_STATUSES.index('paid'))
  end

  def reference
    base = 1000
    (base+id).to_s.rjust(5, "0")
  end

  def paid?
    payment_status == PAYMENT_STATUSES.index('paid')
  end

  def unpaid?
    !paid?
  end

  def payment_status_human
    PAYMENT_STATUSES[payment_status]
  end

  def mark_as_paid!
    self.payment_status = PAYMENT_STATUSES.index('paid')
    save!
  end

  def payment_id
    payment_item.try(:payment_id) || '-'
  end

  def payment_description
    "HYC Payment - #{self.reference}"
  end

  def extras_desc
    CraneHirePrice.extras.map do |chp|
      self.send(chp.code.to_sym) ? chp.code.humanize : nil
    end.compact.to_sentence
  end

  class << self

    def get_crane_hire_time_slot_availability(crane_size, date)
      if date.is_a?(String)
        date = Date.parse(date)
      end

      self.default_time_slots - self.booked_time_slots(crane_size, date)
    end

    def selectable_dates
      CraneHireBooking.connection.execute(
        "select distinct(date) md from (
        select date(crane_hire_primary_start_at) as date from crane_hire_bookings where crane_hire_primary_start_at IS NOT NULL AND DATE(crane_hire_primary_start_at) >= CURDATE()
        union
        select date(crane_hire_secondary_start_at) as date from crane_hire_bookings where crane_hire_secondary_start_at IS NOT NULL AND DATE(crane_hire_secondary_start_at) >= CURDATE()
        union
        select date(cradle_hire_start_at) as date from crane_hire_bookings where cradle_hire_start_at IS NOT NULL AND DATE(cradle_hire_start_at) >= CURDATE()
        union
        select date(cradle_hire_end_at) as date from crane_hire_bookings where cradle_hire_end_at IS NOT NULL AND DATE(cradle_hire_end_at) >= CURDATE()
        ) as dates order by md"
      ).to_a.flatten
    end

    # available slots for crane hire (big or small)
    # every 30 minutes between 11.30am and 8.30 (summer)
    def default_time_slots
      start_time = Time.parse("9:00")
      end_time = Time.parse("20:30")
      slots = []
      t = start_time
      while t <= end_time
        slots << t.strftime("%H:%M")
        t += 30.minutes;
      end

      slots
    end

    def booked_time_slots(crane_size, date)
      if date.is_a?(String)
        date = Date.parse(date)
      end

      # TODO add paid_or_admin
      self.select('crane_hire_primary_start_at, crane_hire_secondary_start_at').
        by_crane_size(crane_size).
        where('crane_hire_primary_start_at IS NOT NULL OR crane_hire_secondary_start_at IS NOT NULL').
        where('DATE(crane_hire_primary_start_at) = :date OR DATE(crane_hire_secondary_start_at) = :date',
          :date => date).map do |b|
        [
          (b.crane_hire_primary_start_at && b.crane_hire_primary_start_at.to_date == date ? b.crane_hire_primary_start_at.strftime("%H:%M") : nil),
          (b.crane_hire_secondary_start_at && b.crane_hire_secondary_start_at.to_date == date ? b.crane_hire_secondary_start_at.strftime("%H:%M") : nil)
        ].compact
      end.flatten.uniq
    end

    def get_cradle_day_unavailability
      # all future cradle bookings
      bookings = self.where("cradle_hire_start_at IS NOT NULL && cradle_hire_start_at > ?", Time.now)

      # create a grouped collection of all days where the cradle is booked
      unavailable_groups = bookings.map do |b|
        (b.cradle_hire_start_at.to_date..b.cradle_hire_end_at.to_date).to_a
      end

      # the user might try to book a cradle for two so we have change the list to
      # add the day before so show that they cant book from that day if they want two days
      # e.g.
      # unavailable days for single day cradle hire: [ [ 02-03, 02-04 ], [ 05-02, 05-03, 05-04 ] ] # two bookings - 1 single day, 1 double day
      # unavailable days for double day cradle hire: [ [ 02-02, 02-03, 02-04 ], [ 05-01, 05-02, 05-03, 05-04 ] ] # add the day before
      double_unavailable_groups = unavailable_groups.map { |group| group.dup.unshift(group.first - 1.day) } # prepend the previous day to start of group

      return {
        :single => unavailable_groups.flatten.uniq,
        :double => double_unavailable_groups.flatten.uniq
      }
    end

    def by_crane_size(crane_size)
      where(:crane_size => crane_size)
    end

    def upcoming
      where("(DATE(crane_hire_primary_start_at) >= CURDATE() OR DATE(cradle_hire_start_at) >= CURDATE())")
    end

    def by_date(date)
      if (date.is_a?(String))
        date = Date.parse(date)
      end

      where("(" +
        "DATE(crane_hire_primary_start_at) = :date OR " +
        "DATE(crane_hire_secondary_start_at) = :date OR " +
        "DATE(cradle_hire_start_at) = :date OR " +
        "DATE(cradle_hire_end_at) = :date" +
       ")", :date => date)
    end
  end

  def calculate_total_charge
    crane_hire_price.try(:price_for_member_type, self.is_member).to_f +
      cradle_hire_price +
      extras_total
  end

  def cradle_hire_price
    price_per_day = CraneHirePrice.cradles.first.price_for_member_type(self.is_member).to_f
    price_per_day * self.requested_cradle_days.to_i
  end

  EXTRA_CODES = [:mast, :one_design]
  def extras_total
    EXTRA_CODES.sum(0) do |extra_code|
      if self.send(extra_code)
        CraneHirePrice.extras.where(:code => extra_code).first.price_for_member_type(self.is_member).to_f
      else
        0
      end
    end
  end

  def extras_charges
    hsh = {}
    EXTRA_CODES.each do |extra_code|
      if self.send(extra_code)
        hsh[extra_code] = CraneHirePrice.extras.where(:code => extra_code).first.price_for_member_type(self.is_member).to_f
      end
    end
    hsh
  end

  def set_charge
    self.total_charge = self.calculate_total_charge
  end

  private
  def set_crane_hire_times
    if self.crane_hire_primary_start_at_date.blank?
      self.crane_hire_primary_start_at_date = Time.current.to_date
    elsif self.crane_hire_primary_start_at_date.is_a?(String)
      self.crane_hire_primary_start_at_date = Time.find_zone!("Dublin").parse(self.crane_hire_primary_start_at_date).to_date
    end

    # dont bother doing this if a cradle has been requested
    if self.requested_cradle_days.present? && self.requested_cradle_days.to_i == 0
      if self.crane_hire_primary_start_at_date.present? && self.crane_hire_primary_start_at_time.present?
        self.crane_hire_primary_start_at = Time.find_zone!("Dublin").parse(self.crane_hire_primary_start_at_date.strftime("%Y-%m-%d") + " " + self.crane_hire_primary_start_at_time)
      end
    else
      self.crane_hire_primary_start_at = self.crane_hire_primary_start_at_date
    end
  end

  def set_cradle_hire_times
    if self.requested_cradle_days.present?
      days = self.requested_cradle_days.to_i # either 0,1,2
      if self.requested_cradle = (days > 0)

        # all cradle hirings start at 11.30 and end at 10.30 the next day (or day after)
        self.cradle_hire_start_at = Time.find_zone!("Dublin").parse(self.crane_hire_primary_start_at_date.strftime("%Y-%m-%d") + " 11:30:00")
        self.cradle_hire_end_at = self.cradle_hire_start_at + days.days - 1.hour

        # the big crane will need to be used to move a boat onto the cradle and that starts at 11.00
        self.crane_hire_primary_start_at = self.cradle_hire_start_at - 30.minutes

        # .. and then we need the big crane again the next day (or day after) at 10.30
        self.crane_hire_secondary_start_at = self.cradle_hire_end_at
      end
    end
  end

  def ensure_no_conflict
    # cradles - check there are no bookings with a start date between the range of another booking
    if self.requested_cradle
      conflicting_cradles = self.class.where("id != ?", self.id).exists?([
        # problem if other cradles start the same day as ours!
        "(DATE(cradle_hire_start_at) = :start_date) OR " +
        # problem if other cradles finish the same day as ours!
        "(DATE(cradle_hire_end_at) = :end_date) OR " +
        "!(" + # negate this
          # other cradles should start and finish before our start date
        " (DATE(cradle_hire_start_at) < :start_date AND DATE(cradle_hire_end_at) <= :start_date ) OR " +
          # other cradles should start and finish after our end date
        " (DATE(cradle_hire_start_at) >= :end_date AND DATE(cradle_hire_end_at) > :end_date ) " +
        ") OR " +
        # any big cranes (with or without cradles) would conflict if they have the same primary start time
        "(crane_size = 'big' AND crane_hire_primary_start_at = :start_time)",
        {:start_date => self.cradle_hire_start_at.to_date,
        :end_date => self.cradle_hire_end_at.to_date,
        :start_time => self.crane_hire_primary_start_at}
      ])

      if (conflicting_cradles)
        self.errors.add(:base, "Sorry but the cradle is already booked for your selected date")
        return false
      end
    else
      search_query = self.class.where("id != ?", self.id).where(:crane_size => self.crane_size)
      # big cranes - check there are no other big crane bookings with the same primary or secondary start
      if crane_size == 'big'
        if search_query.exists?([
          "crane_hire_primary_start_at = :primary_start OR crane_hire_secondary_start_at = :secondary_start",
          {:primary_start => self.crane_hire_primary_start_at,
          :secondary_start => self.crane_hire_secondary_start_at}])
          self.errors.add(:base, "Sorry there is a booking at that time already")
          return false
        end
      else
        # small cranes - check there are no other small crane bookings with the same primary start
        if search_query.exists?(:crane_hire_primary_start_at => self.crane_hire_primary_start_at)
          self.errors.add(:base, "Sorry there is a booking at that time already")
          return false
        end
      end
    end
  end
end

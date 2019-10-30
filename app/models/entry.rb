class Entry < ActiveRecord::Base
  # enumerations
  # STATUSES = ['new', 'approved']
  PAYMENT_STATUSES = ['unpaid', 'paid']

  # default values
  # default_value_for :status, STATUSES.first
  default_value_for :payment_status, PAYMENT_STATUSES.first

  paginates_per 100

  # validations
  validates :entry_form_id, :presence => true
  validates :entry_unique_booking_reference, :uniqueness => true
  validates :owner_name, :presence => true, :if => lambda { |e| e.entry_form.display_owner_name? }
  validates :team, :presence => true, :if => lambda { |e| e.entry_form.display_team? }
  validates :team_captain, :presence => true, :if => lambda { |e| e.entry_form.display_team_captain? }
  validates :phone, :email, :address_line_1, :presence => true, :if => lambda { |e| e.entry_form.display_contact_details? }
  # validates :status, :inclusion => STATUSES
  validates :payment_status, :inclusion => PAYMENT_STATUSES
  validates :terms_agreed, :refund_policy_agreed, :acceptance => true
  validate :validate_custom_fields
  validate :validate_club, :presence => true, :if => lambda { |e| e.entry_form.display_club? }
  validates :email, :email => true

  validates :sail_number, :presence => true, :if => lambda { |e| e.entry_form.display_sail_no? }
  validates :helm_name, :presence => true, :if => lambda { |e| e.entry_form.display_helm? }
  validates :boat_class_id, :presence => true, :if => lambda { |e| e.entry_form.display_boat_class? }
  validates :hull_colour, :presence => true, :if => lambda { |e| e.entry_form.display_hull_colour? }

  validate :required_categories

  # associations
  belongs_to :entry_form
  delegate :event, :to => :entry_form, :allow_nil => true
  belongs_to :boat_class
  delegate :boat_category, :to => :boat_class
  belongs_to :rig
  belongs_to :fleet
  belongs_to :club
  belongs_to :helm_club, :class_name => 'Club'
  belongs_to :crew_club, :class_name => 'Club'
  has_many :charges_entries, :class_name => 'ChargeEntry', :dependent => :destroy
  has_many :charges, :through => :charges_entries, :dependent => :destroy
  has_many :categories, :class_name => 'EntryEntryFormCategory', :source => :entry, :dependent => :destroy
  accepts_nested_attributes_for :categories, :allow_destroy => true
  after_save :remove_all_but_last_categories

  after_validation :set_custom_field_data
  before_save :set_charges, :transform_sail_number
  after_save :update_charge_entries
  has_many :payment_items, :foreign_key => :product_id # there could be many payment attempts for this entry
  belongs_to :payment_item # this is the one successful attempt for this entry
  belongs_to :boat_builder
  belongs_to :fleet
  belongs_to :country

  validate :ensure_charge

  # attributes
  attr_accessor :terms_agreed, :refund_policy_agreed, :charges_accepted, :charge_values, :custom_fields
  serialize :custom_field_data

  # instance methods
  def name
    if helm_name.present?
      helm_name
    elsif owner_name.present?
      owner_name
    end
  end

  def total
    t = 0
    self.charges.each do |c|
      if c.charge_type == 'Quantity'
        if self.charge_values.present?
          quantity = self.charge_values[c.id.to_s]
        elsif self.charges_entries.present?
          quantity = self.charges_entries.to_a.find { |ce| ce.charge_id == c.id }.try(:quantity)
        else
          quantity = 1
        end

        t += (c.price * quantity.to_i)
      elsif c.price.present?
        t += c.price
      end
    end
    t
  end

  def mark_as_paid!
    self.payment_status = 'paid'
    save!
  end

  def paid?
    payment_status == 'paid'
  end

  def unpaid?
    !paid?
  end

  def generate_booking_reference
    # generate random 12 string for entry_unique_booking_reference
    booking_reference = SecureRandom.random_number(36**12).to_s(36).rjust(12, "0").upcase
    unless Entry.where(entry_unique_booking_reference: booking_reference).exists?
      self.entry_unique_booking_reference = booking_reference
    else
      generate_booking_reference
    end
  end

  def reference
    "E#{self.id.to_s.rjust(5, "0")}"
  end

  def sail_number_full
    [sail_number_prefix, sail_number, sail_number_suffix].compact.reject(&:blank?).join('-')
  end

  def payment_id
    payment_item.try(:payment_id) || '-'
  end

  # dynamically define *_club_initials and *_club_name methods
  [:club, :helm_club, :crew_club].each do |club_el|
    define_method :"#{club_el}_initials" do
      if self.send(club_el) && self.send(club_el).initials.present?
        self.send(club_el).initials
      elsif self.send(:"#{club_el}_name").present?
        self.send(:"#{club_el}_name")[0, 4].downcase+'...'
      else
        ''
      end
    end

    define_method :"#{club_el}_name" do
      self.send(:"#{club_el}_name_extra").presence || club.try(:name).presence || ''
    end
  end

  def set_charges(set_defaults = true)
    raise "No entry form!" unless entry_form
    if charges.blank?
      if set_defaults && (default = entry_form.charges.default).present?
        Rails.logger.debug ["default", set_defaults, default].inspect
        charges << default
      end

      if set_defaults && (fixed = entry_form.charges.fixed).present?
        Rails.logger.debug ["fixed", set_defaults, fixed].inspect
        charges << fixed
      end

      if charges_accepted.present?
        Rails.logger.debug ["accepted", charges_accepted].inspect
        charges << charges_accepted
      end
    end
    self.charges.flatten.uniq!
  end

  # we need to do this after saving the object because otherwise the associated charge_entries wont exist
  def update_charge_entries
    Rails.logger.debug ["charge values", self.charge_values, self.charges_entries].inspect
    if self.charge_values.present?
      # update the quantities / names for each associated charge
      self.charge_values.each do |charge_id, value|
        self.charges_entries.each do |charge_entry|
          if charge_entry.charge_id == charge_id
            Rails.logger.debug [value, charge_id].inspect
            Rails.logger.debug charge_entry.inspect
            if value.is_a?(Integer)
              charge_entry.quantity = value
            else
              charge_entry.name = value
            end
            Rails.logger.debug charge_entry.inspect
            unless charge_entry.new_record?
              charge_entry.save
            end
          end
        end
      end
    end

    true
  end

  def payment_description
    "#{event.title} #{boat_name} #{owner_name}"
  end

  def set_entry_number!
    if entry_form && paid? && entry_number.nil?
      transaction do
        highest_entry_number = (self.class.where(:entry_form_id => entry_form_id).maximum('entry_number') || 0)
        self.update_attribute(:entry_number, highest_entry_number + 1)
      end
    end
  end

  # class methods
  class << self
    def build_default(event)
      obj = new(:entry_form_id => event.entry_form.id)
      obj.custom_fields.build
      obj
    end

    def by_event(event)
      joins(:entry_form).where("entry_forms.event_id" => event)
    end

    # def by_status(status)
    #   where(:status => status)
    # end

    def paid
      where(:payment_status => "paid")
    end

    def approved
      where(:status => 'approved')
    end

    def set_all_entry_numbers
      paid.order('created_at asc').each do |entry|
        entry.set_entry_number!
      end
    end
  end

  private
  def validate_custom_fields
    if custom_fields && custom_fields.is_a?(Hash)
      custom_fields.each do |id, value|
        if (custom_field = CustomField.find(id)) && custom_field.is_required? && value.blank?
          errors.add(:base, "#{custom_field.name} is required")
        end
      end
    end
  end

  def validate_club
    if club_id.blank? && club_name_extra.blank?
      errors.add(:base, "You must select a club")
    end
  end

  def set_custom_field_data
    self.custom_field_data = []
  end

  def transform_sail_number
    self.sail_number_prefix.present? && self.sail_number_prefix.upcase!
    self.sail_number_suffix.present? && self.sail_number_suffix.upcase!
    true
  end

  def ensure_charge
    if charges.blank?
      errors.add(:base, "You must choose a fee option")
    end
  end

  # an entry could store multiple answers to a category in entries_entry_form_categories
  # We should remove all but the most recent one
  def remove_all_but_last_categories
    if categories.present?
      self.categories = self.categories.group_by(&:entry_form_category_id).map do |entry_for_category_id, entry_entry_form_categories|
        entry_entry_form_categories.last # the most recent one
      end
    end
  end

  def required_categories
    self.categories.group_by(&:entry_form_category_id).each do |entry_form_category_id, entry_entry_form_categories|
      entry_form_category = self.entry_form.categories.where(:id => entry_form_category_id).first

      # if this category is required and the user has not entered anything!
      if entry_form_category && entry_form_category.is_required? && (entry_entry_form_categories.empty? || entry_entry_form_categories.first.value.nil?)
        self.errors.add(:base, "Category '"+entry_form_category.name+"' is required")
      end
    end
  end
end

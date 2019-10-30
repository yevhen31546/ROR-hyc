class EntryForm < ActiveRecord::Base
  # this contains the information that the system needs to display and process
  # the entry form.
  # Each event contains exactly one entry form.
  # entry forms belong to only one event
  # if you want to use the same type of entry form again on another event, copy it.

  # validations
  validates :event_id, :presence => true, :uniqueness => true

  # associations
  belongs_to :event
  has_many :charges, :dependent => :destroy
  accepts_nested_attributes_for :charges, :allow_destroy => true
  has_many :categories, :class_name => 'EntryFormCategory', :dependent => :destroy
  accepts_nested_attributes_for :categories, :allow_destroy => true

  # has_and_belongs_to_many :boat_classes
  has_many :boat_classes_entry_forms, :class_name => 'BoatClassEntryForm'
  has_many :boat_classes, :through => :boat_classes_entry_forms, :dependent => :destroy
  accepts_nested_attributes_for :boat_classes_entry_forms, :allow_destroy => true

  has_and_belongs_to_many :rigs
  has_and_belongs_to_many :fleets
  has_and_belongs_to_many :clubs, :order => 'name asc'
  has_and_belongs_to_many :countries, :order => 'name asc'
  has_many :entries

  has_many :custom_fields, :dependent => :destroy
  accepts_nested_attributes_for :custom_fields, :allow_destroy => true

  before_validation :check_if_clear_lists

  ## instance methods
  def name
    if self.event
      event.title
    else
      "Entry Form with no event"
    end
  end

  def duplicate(event_id, do_save = false)
    entry_form = self.dup
    entry_form.event_id = event_id
    entry_form.created_at = entry_form.updated_at = Time.now
    entry_form.boat_classes = self.boat_classes
    entry_form.rigs = self.rigs
    entry_form.clubs = self.clubs

    if self.charges.present?
      self.charges.each do |charge|
        entry_form.charges << charge.dup
      end
    end

    if self.categories.present?
      self.categories.each do |category|
        entry_form.categories << category.dup
      end
    end

    if do_save
      entry_form.save!
    end
    entry_form
  end

  def ordered_boat_classes
    boat_classes_entry_forms.order('position asc').collect(&:boat_class)
  end

  def applicable_charges
    [charges.visible.default, charges.visible.fixed, charges.visible.optional.to_a].flatten.compact.sort_by { |c| c.position }
  end

  def admin_applicable_charges
    charges.sort_by { |c| c.position }
  end

  ## class methods
  class << self
    def by_year(year)
      year.present? ? joins(:event).where("YEAR(events.date) = ?", year) : scoped
    end

    def years
      joins(:event).select('distinct(YEAR(events.date)) as year').map(&:year)
    end

    def display_options
      columns.collect(&:name).select { |c| c =~ /^display_/ }
    end
  end

  private
  def check_if_clear_lists
    if (!display_club? && !display_helm_club? && !display_crew_club?) && clubs.present?
      Rails.logger.error "Clearing clubs!"
      clubs.clear
    end

    if !display_rig? && rigs.present?
      Rails.logger.error "Clearing rigs!"
      rigs.clear
    end

    if !display_fleet? && fleets.present?
      Rails.logger.error "Clearing fleets!"
      fleets.clear
    end

    if !display_boat_class? && boat_classes.present?
      Rails.logger.error "Clearing boat classes!"
      boat_classes.clear
    end
  end
end

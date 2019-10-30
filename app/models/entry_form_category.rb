class EntryFormCategory < ActiveRecord::Base

  default_scope :order => 'position asc'

  # validations
  validates :name, :presence => true

  # associations
  belongs_to :entry_form
  has_many :entries_entry_form_categories, :class_name => 'EntryEntryFormCategory'
  has_many :entries, :through => :entries_entry_form_categories, :dependent => :destroy

  default_value_for :position do
    (scoped.maximum(:position) || 0) + 1
  end


  def options_collection
    (options.present? && options.lines) || []
  end

  def get_short_option(option)
    return option unless short_options.present?

    option_index = options_arr.index(option)

    if option_index && option_index >= 0 && short_options_arr[option_index].present?
      return short_options_arr[option_index]
    else
      return option
    end
  end

  def options_arr
    split_options(options)
  end

  def short_options_arr
    split_options(short_options)
  end

  def split_options(options)
    return options.split("\r\n").map(&:strip).select(&:presence).compact
  end
end

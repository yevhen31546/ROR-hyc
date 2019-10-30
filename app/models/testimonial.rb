class Testimonial < ActiveRecord::Base
  validates :name, :quote, :presence => true

  scope :random, :order => "RAND()"

  def date
    created_at.strftime('%d/%m/%Y')
  end

  @@searchable_fields = ["testimonials.name", "testimonials.from", "testimonials.quote"]
  include SimpleTextSearchable

  def to_param
    "#{id}-#{name.parameterize}"
  end
  
end

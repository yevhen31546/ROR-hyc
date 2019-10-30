class TestimonialsController < ApplicationController

  def index
    @testimonials = Testimonial.find(:all)
  end

end

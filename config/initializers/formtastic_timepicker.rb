module Formtastic
  module TimePicker
    protected

    TIME_HR_VALUES = (6..23).to_a.map(&:to_s)
    TIME_MIN_VALUES = ['00', '15', '30', '45']

    def timepicker_input(method, options)
      default_opts = {:hours => TIME_HR_VALUES, :minutes => TIME_MIN_VALUES}
      options = default_opts.deep_merge(options)
      hr_attr = (method.to_s+'_hr').to_sym # e.g. collect_at_time_hr, return_at_time_hr
      min_attr = (method.to_s+'_min').to_sym # e.g. collect_at_time_min, return_at_time_min
      label(method, options.delete(:label)) +
        select_input(hr_attr,
          timepicker_options(:collection => options[:hours],
            :selected => (object.send(hr_attr).try(:strftime, '%H')), :label => false)) +
        ":" +
        select_input(min_attr,
          timepicker_options(:collection => options[:minutes],
            :selected => (object.send(min_attr).try(:strftime, '%M')), :label => false))
    end

    # Generate html input options for the datepicker_input
    #
    def timepicker_options(opts)
      {:input_html => {:class => 'ui-timepicker time'}, :include_blank => false}.deep_merge(opts)
    end
  end
end

Formtastic::SemanticFormBuilder.send(:include, Formtastic::TimePicker)

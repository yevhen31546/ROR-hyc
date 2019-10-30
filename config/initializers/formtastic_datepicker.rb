module Formtastic
  module DatePicker
    protected

    def datepicker_input(method, options = {})
      format = options[:format] || '%d/%b/%Y'
      string_input(method, datepicker_options(format, object.try(:send, method)).deep_merge(options))
    end

    # Generate html input options for the datepicker_input
    #
    def datepicker_options(format, value = nil)
      datepicker_options = {:input_html => {:class => 'ui-datepicker', :value => value.try(:strftime, format)}}
    end
  end
end

Formtastic::SemanticFormBuilder.send(:include, Formtastic::DatePicker)

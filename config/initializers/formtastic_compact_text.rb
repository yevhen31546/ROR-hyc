module Formtastic
  module CompactText
    protected

    def compact_text_input(method, options)
      options.deep_merge!({
        :input_html => {:title => (options[:label] || method.to_s.humanize),
          :class => 'text-hint'}.deep_merge(options[:input_html] || {}),
        :label => false
      })
      basic_input_helper(:text_area, :text, method, options) +
        required_or_optional_string(options.delete(:required))
    end
  end
end

Formtastic::SemanticFormBuilder.send(:include, Formtastic::CompactText)

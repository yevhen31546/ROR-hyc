require 'active_support'
module SettingsUtils
  def self.included(base)
    base.class_eval do
      def self.settings
        SettingsUtils::Base.new
      end

      def settings
        SettingsUtils::Base.new
      end
      alias_method :setting, :settings
      
      helper_method :settings, :setting if respond_to?(:helper_method)
    end
  end

  class << self
    def settings
      SettingsUtils::Base.new
    end
    alias_method :setting, :settings
  end

  class Base
    def [](key)
      setting = Setting.find_by_key(key.to_s)
      out = setting.try(:value)
      case setting.try(:value_type)
      when 'integer'
        out.to_i
      when 'decimal'
        BigDecimal.new(out.to_s)
      else
        out
      end
    end

    def update(attrs = {})
      attrs.each do |key,value|
        result = Setting.find_or_create_by_key(key.to_s)
        result.update_attribute(:value, value) if result
      end
    end
  end
end

ActionController::Base.send(:include, SettingsUtils)
ActiveRecord::Base.send(:include, SettingsUtils)
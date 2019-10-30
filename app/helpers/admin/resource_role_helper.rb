require 'active_support/concern'

module Admin::ResourceRoleHelper
  extend ActiveSupport::Concern
  included do
    class_eval do
      def self.by_role(role)
        includes(:role_resource_access).where(:role_resource_accesses => {:role_id => role.id})
      end
    end
  end
end
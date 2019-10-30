class RoleResourceAccess < ActiveRecord::Base
  belongs_to :role
  belongs_to :object, :polymorphic => true
end
class User < ActiveRecord::Base
  # ROLES = ['admin', 'superadmin', 'editor', 'user']

  has_and_belongs_to_many :admin_modules
  belongs_to :role

  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  def is_admin?
    role.name == 'admin' || is_superadmin?
  end

  def is_superadmin?
    role.name == 'superadmin'
  end

  def is_editor?
    role.name == 'editor'
  end

  def to_s
    login
  end

  @@searchable_fields = ["users.login", "users.email"]
  include SimpleTextSearchable

  def has_access_to_admin_module?(admin_module)
    self.is_superadmin? || self.is_admin? || self.admin_modules.include?(admin_module)
  end
end

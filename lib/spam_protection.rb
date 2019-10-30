module SpamProtection
  def self.included(base)
    base.class_eval do
      attr_accessor :are_you_human
    end

    base.validates :are_you_human, :presence => true, :on => :create
    base.validates_format_of :are_you_human, :with => /^yes$/, :message => 'you might be a spambot', :on => :create
  end
end

class ContactUs < ActiveRecord::Base
  attr_accessor :contact_type, :are_you_human
  set_table_name 'contact_us'
  validates :name, :phone, :are_you_human, :phone,
    :function_date, :arrival_time, :num_attendees,
    :function_type, :menu, :hyc_member, :presence => true
  validates :email, :email => true

  validates :message, :format => {:with => /$^/, :message => 'looks like spam'}, :if => Proc.new { |x| x.message =~ /\[link=|\[url=/ }
  validates :are_you_human, :format => {:with => /^yes$/, :message => 'you might be a spambot'}

  FUNCTION_TYPES = ['Wedding', 'Birthday', 'Anniversary', 'Business', 'Other']
  MENUS = ['Menu A', 'Menu B', 'Menu C', 'Menu D']
end

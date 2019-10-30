class Order < ActiveRecord::Base

  has_many :order_items, :dependent => :destroy
  belongs_to :payment_item, :dependent => :destroy
  accepts_nested_attributes_for  :order_items, reject_if: lambda {|attributes| attributes['amount'].blank? || attributes['product_id'].blank?}

  validates :member_name, :member_id, :email, :presence => true
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :if => Proc.new { |x| x.email.present? }

  PAYMENT_STATUSES = ['unpaid', 'paid']
  default_value_for :payment_status, 0

  def self.paid
    where(payment_status: PAYMENT_STATUSES.index('paid'))
  end

  def total
    order_items.sum(:amount)
  end

  def total_paid
    payment_item.amount
  end

  def reference
    base = 1000
    (base+id).to_s.rjust(5, "0")
  end

  def paid?
    payment_status == PAYMENT_STATUSES.index('paid')
  end

  def unpaid?
    !paid?
  end

  def payment_status_human
    PAYMENT_STATUSES[payment_status]
  end

  def mark_as_paid!
    self.payment_status = PAYMENT_STATUSES.index('paid')
    save!
  end

  def payment_id
    payment_item.try(:payment_id) || '-'
  end

  def payment_description
    "HYC Payment - #{order.reference}"
  end

end
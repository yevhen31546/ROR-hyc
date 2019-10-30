class EventDinnerBooking < ActiveRecord::Base
  validates :email, :event_dinner_id, :name, :phone, :quantity, :table_name, :presence => true
  validates :email, :email => true
  validates :email, uniqueness: { scope: :event_dinner_id, message: "has already booked" }
  validates :refund_policy_agreed, :acceptance => true

  attr_accessor :refund_policy_agreed

  belongs_to :event_dinner
  belongs_to :payment_item, :dependent => :destroy
  PAYMENT_STATUSES = ['unpaid', 'paid']
  default_value_for :payment_status, 0

  before_create :set_charge

  def self.paid
    where(payment_status: PAYMENT_STATUSES.index('paid'))
  end

  def self.paid_or_admin
    where("payment_status = ? OR is_admin = 1", PAYMENT_STATUSES.index('paid'))
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
    "HYC Dinner Payment - #{self.reference}"
  end


  def calculate_total_charge
    self.event_dinner.ticket_price.to_f * self.quantity
  end

  def set_charge
    self.total_charge = self.calculate_total_charge
  end
end

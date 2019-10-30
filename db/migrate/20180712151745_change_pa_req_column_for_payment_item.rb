class ChangePaReqColumnForPaymentItem < ActiveRecord::Migration
  def up
            change_column :payment_items, :pareq, :text

  end

  def down
  end
end

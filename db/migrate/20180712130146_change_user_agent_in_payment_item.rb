class ChangeUserAgentInPaymentItem < ActiveRecord::Migration
  def up
	    change_column :payment_items, :user_agent, :text

  end

  def down
  end
end

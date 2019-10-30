class AddPaResAndBatchIdToPaymentItem < ActiveRecord::Migration
  def change
    add_column :payment_items, :pas_ref, :text
    add_column :payment_items, :batch_id, :string
  end
end

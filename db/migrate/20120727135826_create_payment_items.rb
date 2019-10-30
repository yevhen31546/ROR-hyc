class CreatePaymentItems < ActiveRecord::Migration
  def up
    create_table "payment_items", :force => true do |t|
      t.string  "payment_id",         :limit => 50
      t.integer "user_id"
      t.integer "product_id"
      t.string  "product_type"
      t.string  "payment_method",     :limit => 50
      t.decimal "amount",                            :precision => 8, :scale => 2
      t.string  "currency",           :limit => 10
      t.string  "last_digits",        :limit => 10
      t.integer "expiry_month",       :limit => 1
      t.integer "expiry_year",        :limit => 2
      t.string  "name_on_card",       :limit => 100
      t.string  "user_agent",         :limit => 50
      t.string  "ip_address",         :limit => 50
      t.string  "authorization"
      t.string  "md"
      t.string  "pareq"
      t.string  "acsurl"
    end

    add_index :payment_items, :product_id
    add_index :payment_items, :product_type
    add_index :payment_items, :user_id
  end

  def down
    drop_table :payment_items
  end
end

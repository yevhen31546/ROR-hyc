class CreateCraneHirePrices < ActiveRecord::Migration
  def change
    create_table :crane_hire_prices do |t|
      t.string :name
      t.string :product_type
      t.decimal :member_price, precision: 10, scale: 2
      t.decimal :non_member_price, precision: 10, scale: 2
      t.string :charge_period

      t.timestamps
    end
    add_index :crane_hire_prices, :product_type
  end
end

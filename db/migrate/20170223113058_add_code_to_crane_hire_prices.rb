class AddCodeToCraneHirePrices < ActiveRecord::Migration
  def change
    add_column :crane_hire_prices, :code, :string, :after => :name
  end
end

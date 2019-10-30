class RemoveDiscountEndDateFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :discount_end_date
  end

  def down
  end
end

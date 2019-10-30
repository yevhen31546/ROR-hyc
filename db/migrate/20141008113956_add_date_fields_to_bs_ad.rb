class AddDateFieldsToBsAd < ActiveRecord::Migration
  def change
    add_column :bs_ads, :inactive_date, :datetime
    add_column :bs_ads, :delete_date, :datetime
  end
end

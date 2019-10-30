class RemoveStatusFromCrewFinderAds < ActiveRecord::Migration
  def up
    remove_column :crew_finder_ads, :status
  end

  def down
    add_column :crew_finder_ads, :status, :string
  end
end

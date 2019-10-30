class ChangeCrewFinder < ActiveRecord::Migration
  def up
    remove_column :crew_finder_ads, :name
    add_column :crew_finder_ads, :age, :string
    add_column :crew_finder_ads, :interested_in, :string
    add_column :crew_finder_ads, :availability, :string
    add_column :crew_finder_ads, :preferred_position, :string
    add_column :crew_finder_ads, :experience, :string
  end

  def down
    add_column :crew_finder_ads, :name
    remove_column :crew_finder_ads, :age
    remove_column :crew_finder_ads, :interested_in
    remove_column :crew_finder_ads, :availability
    remove_column :crew_finder_ads, :preferred_position
    remove_column :crew_finder_ads, :experience
  end
end

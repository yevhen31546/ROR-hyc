class CreateCrewFinderAds < ActiveRecord::Migration
  def change
    create_table :crew_finder_ads do |t|
      t.string :name
      t.string :ad_type
      t.text :description
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.string :status
      t.string :ip_address

      t.timestamps
    end
  end
end

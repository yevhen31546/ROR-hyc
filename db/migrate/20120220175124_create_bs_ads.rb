class CreateBsAds < ActiveRecord::Migration
  def change
    create_table :bs_ads do |t|
      t.string :name
      t.string :ad_type
      t.string :category
      t.string :location
      t.text :description, :limit => 1.megabyte
      t.decimal :price, :scale => 2, :precision => 12
      t.string :currency
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.string :status
      t.string :ip_address

      t.timestamps
    end

    add_index :bs_ads, :name
    add_index :bs_ads, :ad_type
    add_index :bs_ads, :category
    add_index :bs_ads, :location
    add_index :bs_ads, :price
    add_index :bs_ads, :currency
    add_index :bs_ads, :status
    add_index :bs_ads, :created_at
  end
end

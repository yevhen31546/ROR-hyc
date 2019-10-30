class AddDocContentTypeToBsAds < ActiveRecord::Migration
  def change
    add_column :bs_ads, :doc_content_type, :string
    add_column :bs_ads, :doc_file_size, :integer
  end
end

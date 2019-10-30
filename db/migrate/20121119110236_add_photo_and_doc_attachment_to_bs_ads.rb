class AddPhotoAndDocAttachmentToBsAds < ActiveRecord::Migration
  def change
    add_column :bs_ads, :photo_file_name, :string
    add_column :bs_ads, :doc_file_name, :string
  end
end

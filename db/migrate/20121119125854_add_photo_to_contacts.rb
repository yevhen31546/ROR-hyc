class AddPhotoToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :photo_file_name, :string
  end
end

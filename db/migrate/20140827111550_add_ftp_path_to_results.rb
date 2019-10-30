class AddFtpPathToResults < ActiveRecord::Migration
  def change
    add_column :results, :ftp_path, :string
  end
end

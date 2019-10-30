class AddHasIrcCertNumberToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :has_irc_cert_number, :boolean, :default => false, :null => false

    add_column :entries, :has_echo_cert_number, :boolean, :default => false, :null => false
    remove_column :entries, :echo_cert_number
  end
end

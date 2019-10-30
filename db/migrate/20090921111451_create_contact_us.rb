class CreateContactUs < ActiveRecord::Migration
  def self.up
    create_table :contact_us do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.text :message, :limit => 1.megabyte

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_us
  end
end

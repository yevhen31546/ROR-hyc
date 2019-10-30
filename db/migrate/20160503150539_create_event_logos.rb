class CreateEventLogos < ActiveRecord::Migration
  def change
    create_table :event_logos do |t|
      t.integer :event_id
      t.has_attached_file :image
      t.string :url

      t.timestamps
    end
    add_index :event_logos, :event_id
  end
end

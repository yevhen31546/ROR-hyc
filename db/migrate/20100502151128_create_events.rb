class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.string :sub_title
      t.text :summary, :limit => 1.megabyte
      t.date :date
      t.date :closing_date
      t.date :discount_end_date

      t.integer :sponsor_logo_id

      t.string :status
      t.string :event_type
      t.string :website

      t.timestamps
    end

    add_index :events, :title
    add_index :events, :sub_title
    add_index :events, :event_type
    add_index :events, :date
    add_index :events, :closing_date
    add_index :events, :discount_end_date
    add_index :events, :status
    add_index :events, :created_at
  end


  def self.down
    drop_table :events
  end
end

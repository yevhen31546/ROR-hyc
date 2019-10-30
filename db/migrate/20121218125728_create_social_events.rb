class CreateSocialEvents < ActiveRecord::Migration
  def change
    create_table :social_events do |t|
      t.string :name
      t.text :description
      t.date :date
      t.boolean :featured

      t.timestamps
    end
  end
end

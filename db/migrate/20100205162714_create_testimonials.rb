class CreateTestimonials < ActiveRecord::Migration
  def self.up
    create_table :testimonials do |t|
      t.string :name
      t.string :from
      t.text :quote
      t.timestamps
    end

    add_index :testimonials, :created_at
  end

  def self.down
    drop_table :testimonials
  end
end

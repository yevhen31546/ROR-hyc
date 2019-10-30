class CreateNavbarItems < ActiveRecord::Migration
  def self.up
    create_table :navbar_items do |t|
      t.integer :navbar_id, :null => false
      t.integer :parent_id
      t.string :name
      t.string :controller
      t.string :action
      t.string :parameters
      t.string :url
      t.string :target
      t.integer :page_id
      t.integer :asset_id
      t.integer :position, :default => 0, :null => false
      t.string :css_class, :null => true

      t.timestamps
    end

    add_index :navbar_items, :navbar_id
    add_index :navbar_items, :parent_id
    add_index :navbar_items, :name
    add_index :navbar_items, :created_at
    add_index :navbar_items, :position
  end

  def self.down
    drop_table :navbar_items
  end
end

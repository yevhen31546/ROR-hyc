class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets, :force => true do |t|
      t.string :type
      t.string :name
      t.string :category
      t.integer :width
      t.integer :height
      t.string :asset_file_name
      t.integer :asset_file_size
      t.string :asset_content_type
      t.datetime :asset_updated_at

      t.timestamps
    end

    add_index :assets, :type
    add_index :assets, :name
    add_index :assets, :category
    add_index :assets, :created_at
  end

  def self.down
    drop_table :assets
  end
end

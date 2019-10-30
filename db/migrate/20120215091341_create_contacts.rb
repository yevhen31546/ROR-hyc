class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :category
      t.string :name
      t.string :position
      t.string :email
      t.string :phone
      t.integer :sort_order

      t.timestamps
    end

    add_index :contacts, :category
    add_index :contacts, :name
    add_index :contacts, :sort_order
    add_index :contacts, :created_at
  end
end

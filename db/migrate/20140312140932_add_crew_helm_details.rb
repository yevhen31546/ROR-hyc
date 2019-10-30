class AddCrewHelmDetails < ActiveRecord::Migration
  def up
    add_column :entries, :crew_phone, :string
    add_column :entries, :crew_address_line_1, :string
    add_column :entries, :crew_address_line_2, :string
    add_column :entries, :crew_address_line_3, :string
    add_column :entries, :crew_address_line_4, :string
    add_column :entries, :crew_email, :string
    add_column :entries, :helm_email, :string
  end

  def down
    remove_column :entries, :crew_phone
    remove_column :entries, :crew_address_line_1
    remove_column :entries, :crew_address_line_2
    remove_column :entries, :crew_address_line_3
    remove_column :entries, :crew_address_line_4
    remove_column :entries, :crew_email
    remove_column :entries, :helm_email
  end
end

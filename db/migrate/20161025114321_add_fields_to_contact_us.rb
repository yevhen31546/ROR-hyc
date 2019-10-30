class AddFieldsToContactUs < ActiveRecord::Migration
  def change
    add_column :contact_us, :hyc_member, :string
    add_column :contact_us, :function_date, :string
    add_column :contact_us, :arrival_time, :string
    add_column :contact_us, :num_attendees, :string
    add_column :contact_us, :function_type, :string
    add_column :contact_us, :menu, :string
  end
end

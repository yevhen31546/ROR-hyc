class ModifyMemberIdColumn < ActiveRecord::Migration
  def up
    change_column :orders, :member_id, :string
  end

  def down
    change_column :orders, :member_id, :integer
  end
end

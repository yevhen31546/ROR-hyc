class CreateTeamMembers < ActiveRecord::Migration
  def self.up
    create_table :team_members do |t|
      t.string :name
      t.string :role
      t.string :department
      t.string :phone, :string
      t.string :mobile, :string      
      t.string :email, :string
      t.text :content, :limit => 1.megabyte
      t.integer :sort
      t.string :photo_file_name
      t.integer :photo_file_size
      t.string :photo_content_type
      t.datetime :photo_updated_at

      t.timestamps
    end

    add_index :team_members, :sort
  end

  def self.down
    drop_table :team_members
  end
end

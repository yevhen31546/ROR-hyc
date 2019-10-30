class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages, :force => true do |t|
      t.string :title
      t.string :url
      t.string :code
      t.text :content, :limit => 1.megabyte
      t.string :extended_title
      t.string :seo_title
      t.string :seo_description
      t.string :robots, :string
      t.string :canonical, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end

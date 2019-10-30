class AddEventTitleToResults < ActiveRecord::Migration
  def up
    add_column :results, :event_title, :string
    Result.all.each { |r| r.event_title = r.event.try(:title); r.save }
  end

  def down
  end
end

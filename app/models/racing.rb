class Racing < ActiveRecord::Base

  SEARCHABLE_FIELDS = [:race_officer, :assistant_race_officer, :boat_assisting]

  def self.by_month(year, month)
    Racing.where("YEAR(DATE(event_date)) = ? and MONTH(DATE(event_date)) = ?", year, month)
  end

  def self.by_filter(value)
    return scoped if value.strip == ""

    table = self.arel_table
    searchable_fields = SEARCHABLE_FIELDS.dup

    filter = table[searchable_fields.shift].matches("%#{value}%")
    searchable_fields.each do |field|
      filter = filter.or(table[field].matches("%#{value}%"))
    end
    Racing.where(filter)
  end

end

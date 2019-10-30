module SimpleTextSearchable
  def self.included(base)
    base.class_eval do
      cattr_accessor :searchable_fields, :searchable_includes

      scope :by_query, lambda { |query, fields = :all|
        return {} unless query
        words = query.gsub(/\\/, '\&\&').gsub(/'/, "''").split(' ')

        query_searchable_fields = (fields == :all ? searchable_fields : [fields].flatten)

        conds = query_searchable_fields.map do |field|
          words.map {|word| "#{field} LIKE '%#{word}%'"}
        end.flatten.join(' OR ')
        {:conditions => conds, :include => searchable_includes}
      }
    end
  end
end
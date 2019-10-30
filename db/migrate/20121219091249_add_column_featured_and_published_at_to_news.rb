class AddColumnFeaturedAndPublishedAtToNews < ActiveRecord::Migration
  def change
    add_column :news_items, :featured, :boolean
    add_column :news_items, :publish_at, :datetime
  end
end

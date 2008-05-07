class AddHomeDataToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :home_text, :text
    add_column :sites, :home_news_item_count, :integer, :default => 0
  end

  def self.down
    remove_column :sites, :home_text
    remove_column :sites, :home_news_item_count
  end
end

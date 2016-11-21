class AddGoogleAnalyticsToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :google_analytics_code, :string
  end

  def self.down
    remove_column :sites, :google_analytics_code
  end
end

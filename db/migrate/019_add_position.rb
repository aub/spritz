class AddPosition < ActiveRecord::Migration
  def self.up
    add_column :portfolios, :position, :integer, :default => 1
    add_column :news_items, :position, :integer, :default => 1
    add_column :links, :position, :integer, :default => 1
    add_column :assigned_assets, :position, :integer, :default => 1
  end

  def self.down
    remove_column :portfolios, :position
    remove_column :news_items, :position
    remove_column :links, :position
    remove_column :assigned_assets, :position
  end
end

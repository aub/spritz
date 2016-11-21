class AddAssetFields < ActiveRecord::Migration
  def self.up
    add_column :assets, :fields, :text
  end

  def self.down
    remove_column :assets, :fields
  end
end

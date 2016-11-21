class AddMarkToAssignedAssets < ActiveRecord::Migration
  def self.up
    add_column :assigned_assets, :marker, :string
  end

  def self.down
    remove_column :assigned_assets, :marker
  end
end

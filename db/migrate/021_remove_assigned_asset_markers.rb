class RemoveAssignedAssetMarkers < ActiveRecord::Migration
  def self.up
    remove_column :assigned_assets, :marker
  end

  def self.down
    add_column :assigned_assets, :marker, :string
  end
end

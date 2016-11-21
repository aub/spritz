class GenericizeAssetAssignee < ActiveRecord::Migration
  def self.up
    rename_column :assigned_assets, :portfolio_id, :asset_holder_id
    add_column :assigned_assets, :asset_holder_type, :string
  end

  def self.down
    rename_column :assigned_assets, :asset_holder_id, :portfolio_id
    remove_column :assigned_assets, :asset_holder_type
  end
end

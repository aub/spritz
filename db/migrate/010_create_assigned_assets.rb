class CreateAssignedAssets < ActiveRecord::Migration
  def self.up
    create_table :assigned_assets do |t|
      t.references :portfolio, :asset
      t.timestamps
    end
  end

  def self.down
    drop_table :assigned_assets
  end
end

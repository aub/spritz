class AssignAssetsOnlyToPortfolios < ActiveRecord::Migration
  def self.up
    change_table :assigned_assets do |t|
      t.remove :asset_holder_id
      t.remove :asset_holder_type
      t.references :portfolio
    end
  end

  def self.down
    change_table :assigned_assets do |t|
      t.remove :portfolio_id
      t.integer :asset_holder_id
      t.string :asset_holder_type
    end
  end
end

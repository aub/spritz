class AssignedAsset < ActiveRecord::Base

  acts_as_reorderable

  belongs_to :asset
  belongs_to :portfolio

  validates_existence_of :asset, :portfolio

  validates_uniqueness_of :asset_id, :scope => [:portfolio_id]
end

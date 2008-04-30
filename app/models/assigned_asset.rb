class AssignedAsset < ActiveRecord::Base

  belongs_to :asset
  belongs_to :portfolio

  validates_presence_of :asset_id, :portfolio_id
  validates_uniqueness_of :asset_id, :scope => :portfolio_id

  def to_liquid
    AssignedAssetDrop.new self
  end

end

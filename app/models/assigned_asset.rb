class AssignedAsset < ActiveRecord::Base

  acts_as_reorderable

  belongs_to :asset
  belongs_to :asset_holder, :polymorphic => true

  validates_existence_of :asset, :asset_holder

  validates_presence_of :asset_holder_type
  validates_uniqueness_of :asset_id, :scope => [:asset_holder_id, :asset_holder_type]

end

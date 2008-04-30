class Portfolio < ActiveRecord::Base
  
  belongs_to :site

  acts_as_nested_set :scope => :site_id

  validates_presence_of :title
  validates_length_of :title, :maximum => 50
  
  has_many :assigned_assets
  has_many :assets, :through => :assigned_assets
  
  def to_liquid
    PortfolioDrop.new self
  end
end

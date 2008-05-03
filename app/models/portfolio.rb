class Portfolio < ActiveRecord::Base
  
  belongs_to :site
  
  acts_as_nested_set :scope => :site_id

  validates_presence_of :title
  validates_length_of :title, :maximum => 50
  
  has_many :assigned_assets, :conditions => ['marker = ?', 'display'], :dependent => :destroy do
    def build(params=nil)
      AssignedAsset.new((params || {}).merge({ :portfolio_id => proxy_owner.id, :marker => 'display' }))
    end
    
    def create(params=nil)
      AssignedAsset.create((params || {}).merge({ :portfolio_id => proxy_owner.id, :marker => 'display' }))
    end
  end
  has_many :assets, :through => :assigned_assets
  
  attr_accessible :title, :body
  
  def to_liquid
    PortfolioDrop.new self
  end
end

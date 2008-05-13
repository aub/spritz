class Portfolio < ActiveRecord::Base
  
  belongs_to :site
  
  acts_as_nested_set :scope => :site_id

  # column_to_html :body
  before_save :convert_column_to_html

  validates_presence_of :title
  validates_length_of :title, :maximum => 100
  
  has_many :assigned_assets, :as => :asset_holder, :dependent => :destroy, :order => :position do
    # change the order of the assigned_assets in the portfolio by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_assigned_assets, sorted_ids)
    end    
  end
  has_many :assets, :through => :assigned_assets, :order => 'assigned_assets.position'
  
  attr_accessible :title, :body
  
  def to_liquid
    PortfolioDrop.new self
  end
  
  protected
  
  def convert_column_to_html
    self.body_html = BlueCloth.new(self.body || '').to_html
  end

  # A helper method for reordering the assigned assets.
  def reorder_assigned_assets(*sorted_ids)
    transaction do
      sorted_ids.flatten.each_with_index do |thing_id, pos|
        AssignedAsset.update_all ['position = ?', pos], ['id = ? and asset_holder_id = ? and asset_holder_type = ?', thing_id, self.id, 'Portfolio']
      end
    end
  end
end

class Portfolio < ActiveRecord::Base
  
  belongs_to :site
  
  acts_as_nested_set :scope => :site_id

  # column_to_html :body
  before_save :convert_column_to_html

  validates_presence_of :title
  validates_length_of :title, :maximum => 50
  
  has_many :assigned_assets, :as => :asset_holder, :dependent => :destroy
  has_many :assets, :through => :assigned_assets
  
  attr_accessible :title, :body
  
  def to_liquid
    PortfolioDrop.new self
  end
  
  protected
  
  def convert_column_to_html
    self.body_html = BlueCloth.new(self.body || '').to_html
  end
  
end

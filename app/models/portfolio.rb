class Portfolio < ActiveRecord::Base
  
  belongs_to :site

  validates_presence_of :title
  validates_length_of :title, :maximum => 50
  
  def to_liquid
    PortfolioDrop.new self
  end
end

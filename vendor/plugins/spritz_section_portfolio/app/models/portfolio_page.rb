class PortfolioPage < ActiveRecord::Base
  
  belongs_to :section

  def to_liquid
    PortfolioPageDrop.new self
  end
end
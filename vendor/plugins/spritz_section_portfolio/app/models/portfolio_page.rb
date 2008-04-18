class PortfolioPage < ActiveRecord::Base
  
  belongs_to :section

  validates_presence_of :section_id, :name
  
  acts_as_nested_set :scope => :section_id

  def to_liquid
    PortfolioPageDrop.new self
  end
end
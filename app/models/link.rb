class Link < ActiveRecord::Base
  
  belongs_to :site
  
  def to_liquid
    LinkDrop.new self
  end
end

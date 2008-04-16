class Link < ActiveRecord::Base
  
  belongs_to :section

  def to_liquid
    LinkDrop.new self
  end
end
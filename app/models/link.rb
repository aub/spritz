class Link < ActiveRecord::Base
  
  belongs_to :site
  
  validates_presence_of :url
  validates_length_of :url, :minimum => 3
  
  def to_liquid
    LinkDrop.new self
  end
end

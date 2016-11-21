class NewsItem < ActiveRecord::Base

  acts_as_reorderable
  
  belongs_to :site
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 100

  column_to_html :text

  attr_accessible :text, :title, :position
  
  def to_liquid
    NewsItemDrop.new self
  end
end

class NewsItem < ActiveRecord::Base
  
  belongs_to :site
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 50

  def to_liquid
    NewsItemDrop.new self
  end
  
end

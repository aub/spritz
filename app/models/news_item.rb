class NewsItem < ActiveRecord::Base
  
  belongs_to :site
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 50

  # column_to_html :text
  before_save :convert_column_to_html

  def to_liquid
    NewsItemDrop.new self
  end
  
  protected
  
  def convert_column_to_html
    self.text_html = BlueCloth.new(self.text || '').to_html
  end
end

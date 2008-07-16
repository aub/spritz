class Gallery < ActiveRecord::Base
  
  belongs_to :site
  
  validates_presence_of :name
  
  # column_to_html :text
  before_save :convert_column_to_html
  
  def to_liquid
    GalleryDrop.new self
  end
  
  protected
  
  def convert_column_to_html
    self.description_html = RedCloth.new(self.description || '').to_html
  end
  
end

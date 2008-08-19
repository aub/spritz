class Gallery < ActiveRecord::Base

  acts_as_reorderable
  
  belongs_to :site
  
  validates_presence_of :name
  
  column_to_html :text
  # before_save :convert_column_to_html

  attr_accessible :name, :address, :city, :state, :zip, :country, :phone, :email, :url, :description, :position
  
  def to_liquid
    GalleryDrop.new self
  end
  
  protected
  
  # def convert_column_to_html
  #   self.description_html = RedCloth.new(self.description || '').to_html
  # end
  
end

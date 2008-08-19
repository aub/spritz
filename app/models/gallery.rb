class Gallery < ActiveRecord::Base

  acts_as_reorderable
  
  belongs_to :site
  
  validates_presence_of :name
  
  column_to_html :text

  attr_accessible :name, :address, :city, :state, :zip, :country, :phone, :email, :url, :description, :position
  
  def to_liquid
    GalleryDrop.new self
  end
  
end

class GalleryDrop < BaseDrop
  include WhiteListHelper
  
  liquid_attributes << :name << :address << :city << :state << :zip << :country << :phone << :email << :url
  
  def description
    white_list(source.description_html)
  end
end
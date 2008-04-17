# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def asset_image_tag(asset, thumbnail = :display, options = {})
    image_tag(asset.public_filename(thumbnail), options)
  end  
end

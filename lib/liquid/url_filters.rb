module UrlFilters
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  
  # def link_to_asset(asset, *args)
  #   text = h(args[0]) || image_tag(asset.thumbnail_path)
  #   content_tag :a, text, { :href => asset['url'] }
  # end
    
end

Liquid::Template.register_filter UrlFilters

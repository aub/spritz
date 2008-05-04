module UrlFilters
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  
  def stylesheet(stylesheet, media = nil)
    stylesheet << '.css' unless stylesheet.include? '.'
    tag 'link', :rel => 'stylesheet', :type => 'text/css', :href => "/theme/stylesheets/#{stylesheet}", :media => media
  end

  def javascript(javascript)
    javascript << '.js' unless javascript.include? '.'
    content_tag 'script', '', :type => 'text/javascript', :src => "/theme/javascripts/#{javascript}"
  end
    
end

Liquid::Template.register_filter UrlFilters

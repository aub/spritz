module TextFilters
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  
  def limit_length(text, length=50)
    if text.size > length
      text.slice(0, length).rstrip + '...'
    else
      text
    end
  end
end

Liquid::Template.register_filter TextFilters

module UrlFilters
  
  def link_to_page(page, *args)
    "<a href=\"#{page.url}\">#{page['name']}</a>"
  end
end

Liquid::Template.register_filter UrlFilters

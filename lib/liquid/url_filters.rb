module UrlFilters
  
  def link_to_section(section, *args)
    "<a href=\"#{section.url}\">#{section['title']}</a>"
    # url = "haha"
    # "<a href=\"#{url}\">#{section.name}</a>"
  end
end

Liquid::Template.register_filter UrlFilters

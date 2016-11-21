class NewsItemDrop < BaseDrop
  include WhiteListHelper
  
  liquid_attributes << :title
  
  def text
    white_list(source.text_html)
  end
end
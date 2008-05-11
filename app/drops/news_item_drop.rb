class NewsItemDrop < BaseDrop
  liquid_attributes << :title
  
  def text
    source.text_html
  end
end
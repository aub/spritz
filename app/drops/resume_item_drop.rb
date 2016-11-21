class ResumeItemDrop < BaseDrop
  
  def text
    source.text_html
  end
end
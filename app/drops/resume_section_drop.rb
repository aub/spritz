class ResumeSectionDrop < BaseDrop
  liquid_attributes << :title
  
  def items
    @items ||= source.resume_items.collect(&:to_liquid)
  end
end
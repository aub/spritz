class SiteDrop < BaseDrop
  liquid_attributes << :title
  
  def links
    @links ||= source.links.collect(&:to_liquid)
  end  
end
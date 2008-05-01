class SiteDrop < BaseDrop
  liquid_attributes << :title
  
  def links
    @links ||= source.links.collect(&:to_liquid)
  end
  
  def portfolios
    # This method should return only the root-level portfolios.
    @portfolios ||= source.portfolios.find_roots.collect(&:to_liquid)
  end
end
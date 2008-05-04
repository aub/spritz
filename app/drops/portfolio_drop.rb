class PortfolioDrop < BaseDrop
  liquid_attributes << :title << :body
  
  def assets
    @assets ||= source.assigned_assets.collect(&:to_liquid)
  end
  
  def title_asset
    assets.first
  end
  
  def url
    "/portfolios/#{source.to_param}"
  end
  
  def children
    source.children.collect(&:to_liquid)
  end
  
  def ancestors
    source.ancestors.collect(&:to_liquid)
  end
end
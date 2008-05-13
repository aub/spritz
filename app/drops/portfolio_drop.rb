class PortfolioDrop < BaseDrop
  include WhiteListHelper
  
  liquid_attributes << :title
  
  def body
    white_list(source.body_html)
  end
  
  def assets
    @assets ||= source.assigned_assets.collect { |aa| PortfolioItemDrop.new(aa) }
  end
  
  def title_asset
    @title_asset ||= assets.first
  end
  
  def url
    liquidate("/portfolios/#{source.to_param}")
  end
  
  def children
    @children ||= source.children.collect(&:to_liquid)
  end
  
  def ancestors
    @ancestors ||= source.ancestors.collect(&:to_liquid)
  end
end
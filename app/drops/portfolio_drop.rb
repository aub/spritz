class PortfolioDrop < BaseDrop
  include WhiteListHelper
  
  liquid_attributes << :title

  def initialize(source)
    # fill in methods for access to the various forms of the cover image
    has_attached_image(:cover_image, :cover_image)
    super
  end
  
  def body
    white_list(source.body_html)
  end
  
  def assets
    @assets ||= source.assigned_assets.collect { |aa| AssetDrop.new(aa.asset, source) }
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
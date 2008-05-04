class AssignedAssetDrop < BaseDrop
  
  def display_path
    @display_path ||= asset.public_filename(:display)
  end
  
  def thumbnail_path
    @thumbnail_path ||= asset.public_filename(:thumb)
  end

  def tiny_path
    @tiny_path ||= asset.public_filename(:tiny)
  end
  
  def url
    "/portfolios/#{source.portfolio.to_param}/items/#{source.to_param}"
  end
  
  def portfolio
    @portfolio ||= source.portfolio.to_liquid
  end
  
  protected
  
  def asset
    source.asset
  end
end
class PortfolioItemDrop < BaseDrop
  
  def display_path
    @display_path ||= asset.attachment.url(:display)
  end
  
  def medium_path
    @medium_path ||= asset.attachment.url(:medium)
  end
  
  def thumbnail_path
    @thumbnail_path ||= asset.attachment.url(:thumb)
  end

  def tiny_path
    @tiny_path ||= asset.attachment.url(:tiny)
  end
  
  # Get the list of fields for the asset as a hash, leaving out
  # fields that have no value.
  def fields
    @fields ||= Asset::FIELD_NAMES.inject([]) do |list,fn|
      value = liquidate(asset.send(fn))
      value.blank? ? list : list << { 'name' => fn.to_s, 'value' => value }
    end
  end
  
  def url
    "/portfolios/#{source.asset_holder.to_param}/items/#{source.to_param}"
  end
  
  def portfolio
    @portfolio ||= source.asset_holder
  end
  
  protected
  
  def asset
    source.asset
  end
end
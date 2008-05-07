class AssignedAssetDrop < BaseDrop
  
  def display_path
    @display_path ||= asset.public_filename(:display)
  end
  
  def medium_path
    @medium_path ||= asset.public_filename(:medium)
  end
  
  def thumbnail_path
    @thumbnail_path ||= asset.public_filename(:thumb)
  end

  def tiny_path
    @tiny_path ||= asset.public_filename(:tiny)
  end
  
  # Get the list of fields for the asset as a hash, leaving out
  # fields that have no value.
  def fields
    @fields ||= Asset.field_names.inject([]) do |list,fn|
      value = asset.send(fn)
      value.nil? ? list : list << { 'name' => fn.to_s, 'value' => value }
    end
    
    # @fields ||= Asset.field_names.inject({}) do |list,fn|
    #   value = asset.send(fn)
    #   value.nil? ? list : list.merge({ fn => asset.send(fn) })
    # end
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
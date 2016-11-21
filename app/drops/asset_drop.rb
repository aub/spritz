class AssetDrop < BaseDrop
  
  def initialize(source, portfolio)
    # fill in methods for access to the various forms of the attachment
    has_attached_image(:attachment)
    @portfolio = portfolio
    super(source)
  end
  
  # Get the list of fields for the asset as a hash, leaving out
  # fields that have no value.
  def fields
    @fields ||= Asset::FIELD_NAMES.inject([]) do |list,fn|
      value = liquidate(source.send(fn))
      value.blank? ? list : list << { 'name' => fn.to_s, 'value' => value }
    end
  end
  
  def url
    "/portfolios/#{@portfolio.to_param}/items/#{source.to_param}"
  end
  
  def portfolio
    @portfolio
  end
  
  protected
  
  def asset
    source.asset
  end
end
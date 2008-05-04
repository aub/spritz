class SiteDrop < BaseDrop
  liquid_attributes << :title
  
  def links
    @links ||= source.links.collect(&:to_liquid)
  end
  
  def portfolios
    # This method should return only the root-level portfolios.
    @portfolios ||= source.root_portfolios.collect(&:to_liquid)
  end
  
  def news_items
    @news_items ||= source.news_items.collect(&:to_liquid)
  end
end
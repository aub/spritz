class SiteDrop < BaseDrop
  liquid_attributes << :title << :home_text
  
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
  
  def home_news_items
    news_items[0..source.home_news_item_count-1] unless source.home_news_item_count <= 0
  end
  
  def home_image_path
    @home_image_path ||= source.assets.first.public_filename(:display)
  end
end
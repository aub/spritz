class SiteDrop < BaseDrop
  include WhiteListHelper
  
  liquid_attributes << :title << :google_analytics_code
  
  liquid_associations << :links << { :portfolios => :root_portfolios } << :news_items << :resume_sections << :galleries

  def initialize(source)
    # fill in methods for access to the various forms of the home image
    has_attached_image(:home_image, :home_image)
    super
  end
  
  def home_text
    white_list(source.home_text_html)
  end
      
  def home_news_item_count
    (((source.home_news_item_count || 0) > 0) && news_items.size > 0) ? [news_items.size, source.home_news_item_count].min : 0
  end
  
  def home_news_items
    # This is funky, but it says that if the home news count is nil or less than 0 to return an empty array.
    ((source.home_news_item_count || 0) > 0) ? news_items[0..source.home_news_item_count-1] : []
  end
end
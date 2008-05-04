class NewsItemsController < ContentController
  
  def index
    render :template => 'news_items'
  end
end

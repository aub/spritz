class NewsController < ContentController

  caches_with_references :show
  
  def show
    render :template => 'news'
  end
end

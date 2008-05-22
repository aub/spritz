class NewsController < ContentController
  
  def show
    render :template => 'news'
  end
end

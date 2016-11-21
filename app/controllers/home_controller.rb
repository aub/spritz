class HomeController < ContentController

  caches_with_references :show
  
  def show
    render :template => 'home'
  end
end

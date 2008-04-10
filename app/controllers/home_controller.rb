class HomeController < ContentController

  caches_action_with_references :show
  
  def show
  end
end

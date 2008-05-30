class LinksController < ContentController

  caches_with_references :show
  
  def show
    render :template => 'links'
  end
end

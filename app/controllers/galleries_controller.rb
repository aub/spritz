class GalleriesController < ContentController

  caches_with_references :show
  
  def show
    render :template => 'galleries'
  end
end
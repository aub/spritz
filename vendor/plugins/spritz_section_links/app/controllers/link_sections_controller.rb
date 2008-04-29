class LinkSectionsController < ContentController
  def show
    @section = @site.sections.find(params[:id])
    render :template => 'links'
  end  
end
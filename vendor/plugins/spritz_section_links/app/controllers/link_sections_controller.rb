class LinkSectionsController < ContentController
  def show
    @section = @site.sections.find(params[:id])
  end
end
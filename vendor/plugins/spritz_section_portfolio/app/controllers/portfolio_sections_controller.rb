class PortfolioSectionsController < ContentController

  def show
    @page = @site.sections.find(params[:id]).portfolio
    render :template => 'page'
  end
end
class PortfolioPagesController < ContentController

  def show
    @portfolio = @site.sections.find(params[:portfolio_section_id])
    @page = @portfolio.portfolio_pages.find(params[:id])
    render :template => 'page'
  end
end
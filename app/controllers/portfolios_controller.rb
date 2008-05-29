class PortfoliosController < ContentController
  
  caches_with_references :show
  
  def show
    @portfolio = @site.portfolios.find(params[:id])
    render :template => 'portfolio'
  end
end

class PortfoliosController < ContentController
  
  def show
    @portfolio = @site.portfolios.find(params[:id])
    render :template => 'portfolio'
  end
end

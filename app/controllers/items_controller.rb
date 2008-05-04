class ItemsController < ContentController
  
  def show
    @portfolio = @site.portfolios.find(params[:portfolio_id])
    @item = @portfolio.assigned_assets.find(params[:id])
    render :template => 'portfolio'
  end
end

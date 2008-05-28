class ItemsController < ContentController
  
  def show
    @portfolio = @site.portfolios.find(params[:portfolio_id])
    @item = PortfolioItemDrop.new(@portfolio.assigned_assets.find(params[:id]))
    render :template => 'portfolio_item'
  end
end

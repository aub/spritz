class ItemsController < ContentController
  
  caches_with_references :show
  
  def show
    @portfolio = @site.portfolios.find(params[:portfolio_id])
    @item = AssetDrop.new(@portfolio.assigned_assets.find_by_asset_id(params[:id]).asset, @portfolio)
    render :template => 'portfolio_item'
  end
end

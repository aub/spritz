class Admin::AssignedAssetsController < Admin::AdminController
  
  before_filter :find_portfolio
  
  # POST /portfolios/1/assigned_assets
  # POST /portfolios/1/assigned_assets.xml
  def create
    @assigned_asset = @portfolio.assigned_assets.create(:asset_id => params[:asset_id])
    respond_to do |format|
      if @assigned_asset.save
        flash[:notice] = 'Assigned asset was successfully created.'
        format.html { redirect_to edit_admin_portfolio_path(@portfolio) }
        format.xml  { render :xml => @assigned_asset, :status => :created, :location => @assigned_asset }
      else
        flash[:error] = "Failed to create the assigned asset"
        format.html { redirect_to edit_admin_portfolio_path(@portfolio) }
        format.xml  { render :xml => @assigned_asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /portfolios/1/assigned_assets/1
  # DELETE /portfolios/1/assigned_assets/1.xml
  def destroy
    @assigned_asset = @portfolio.assigned_assets.find(params[:id])
    @assigned_asset.destroy
    respond_to do |format|
      format.html { redirect_to edit_admin_portfolio_path(@portfolio) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_portfolio
    @portfolio = @site.portfolios.find(params[:portfolio_id])
  end
end

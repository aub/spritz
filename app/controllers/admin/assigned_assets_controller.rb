class Admin::AssignedAssetsController < Admin::AdminController
  include Admin::AdminHelper
  
  before_filter :find_portfolio
  before_filter :find_assets, :only => [:new]
  before_filter :make_default_selected_list

  # GET /portfolios/1/assigned_assets/new
  # GET /portfolios/1/assigned_assets/new.xml
  def new
    @selected_assets = @site.assets.find_all_by_id(session[:selected_assets])
    @selected_assets = session[:selected_assets].collect { |id| @selected_assets.find { |ass| ass.id.to_s == id } }
    respond_to do |format|
      format.html # new.html.erb
      format.xml do
        assigned_asset = @portfolio.assigned_assets.build
        render :xml => assigned_asset
      end
    end
  end

  # POST /portfolios/1/assigned_assets/select?asset_id=1&page=1
  def select
    session[:selected_assets] = (session[:selected_assets] || []).push(params[:asset_id]).uniq
    respond_to do |format|
      format.html { redirect_to_new }
    end
  end
  
  # DELETE /portfolios/1/assigned_assets/deselect?asset_id=1&page=1
  def deselect
    session[:selected_assets] = (session[:selected_assets] || []) - [params[:asset_id]]
    respond_to do |format|
      format.html { redirect_to_new }
    end
  end

  # DELETE /portfolios/1/assigned_assets/clear?page=1
  def clear
    session[:selected_assets] = []
    respond_to do |format|
      format.html { redirect_to_new }
    end
  end
  
  # POST /portfolios/1/assigned_assets
  # POST /portfolios/1/assigned_assets.xml
  def create
    added_count = 0
    (params[:assets] || []).each do |asset_id|
      aa = @portfolio.assigned_assets.create({ :asset_id => asset_id })
      added_count += 1 if aa.save
    end
    session[:selected_assets] = []
    respond_to do |format|
      if added_count > 0
        flash[:notice] = "Successfully added #{added_count} #{assets_name.downcase}"
        format.html { redirect_to edit_admin_portfolio_path(@portfolio) }
        format.xml  { render :xml => @assigned_asset, :status => :created, :location => @assigned_asset }
      else
        flash[:error] = "Failed to add the #{asset_name}."
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
  
  def find_assets
    @assets = @site.assets.paginate :page => params[:page], :per_page => 18
  end
  
  def redirect_to_new
    redirect_to new_admin_portfolio_assigned_asset_path(@portfolio, :page => (params[:page] || 1))
  end
  
  def make_default_selected_list
    session[:selected_assets] ||= []
  end
end

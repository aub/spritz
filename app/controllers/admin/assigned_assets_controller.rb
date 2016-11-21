class Admin::AssignedAssetsController < Admin::AdminController
  include Admin::AdminHelper

  cache_sweeper :assigned_asset_sweeper, :only => [:create, :destroy, :update_order]
  
  before_filter :find_portfolio
  before_filter :find_assets, :only => [:new]
  before_filter :make_default_selected_list, :only => [:new, :select, :deselect, :clear, :create]

  # GET /portfolios/1/assigned_assets/new
  def new
    @selected_assets = @site.assets.find_all_by_id(session[:selected_assets])
    @selected_assets = session[:selected_assets].collect { |id| @selected_assets.find { |ass| ass.id.to_s == id } }
  end

  # POST /portfolios/1/assigned_assets/select?asset_id=1&page=1
  def select
    session[:selected_assets] = (session[:selected_assets] || []).push(params[:asset_id]).uniq
    redirect_to_new
  end
  
  # DELETE /portfolios/1/assigned_assets/deselect?asset_id=1&page=1
  def deselect
    session[:selected_assets] = (session[:selected_assets] || []) - [params[:asset_id]]
    redirect_to_new
  end

  # DELETE /portfolios/1/assigned_assets/clear?page=1
  def clear
    session[:selected_assets] = []
    redirect_to_new
  end
  
  # POST /portfolios/1/assigned_assets
  def create
    added_count = 0
    # This position fun is in order to make sure that we add the assets to the end of the list.
    last_position = @portfolio.last_asset_position
    (params[:assets] || []).each do |asset_id|
      aa = @portfolio.assigned_assets.create({ :asset_id => asset_id, :position => last_position + 1 })
      if aa.valid?
        added_count += 1
        last_position += 1
      end
    end
    session[:selected_assets] = []
    if added_count > 0
      flash[:notice] = "Successfully added #{added_count} #{assets_name.downcase}"
    else
      flash[:error] = "Failed to add the #{asset_name}."
    end
    redirect_to edit_admin_portfolio_path(@portfolio)
  end

  # DELETE /portfolios/1/assigned_assets/1
  def destroy
    @assigned_asset = @portfolio.assigned_assets.find(params[:id])
    @assigned_asset.destroy
    redirect_to edit_admin_portfolio_path(@portfolio)
  end
  
  def reorder
    @assigned_assets = @portfolio.assigned_assets
  end
  
  def update_order
    @portfolio.assigned_assets.reorder! params[:assigned_assets]
    render :nothing => true
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

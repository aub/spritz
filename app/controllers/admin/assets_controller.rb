class Admin::AssetsController < Admin::AdminController

  include Admin::AdminHelper

  cache_sweeper :asset_sweeper, :only => [:update]

  before_filter :find_asset, :only => [:edit, :update, :destroy]

  # GET /admin/assets
  def index
    @assets = @site.assets.paginate :page => params[:page], :per_page => 18
  end

  # GET /admin/assets/new
  def new
    @asset = @site.assets.build
  end

  # GET /admin/assets/1/edit
  def edit
  end

  # POST /admin/assets
  def create
    @asset = @site.assets.create(params[:asset])
    if @asset.valid?
      flash[:notice] = 'The ' + asset_name.downcase + ' was successfully created.'
      render :action => 'edit'
    else
      render :action => "new"
    end
  end

  # PUT /admin/assets/1
  def update
    if @asset.update_attributes(params[:asset])
      flash[:notice] = 'The ' + asset_name.downcase + ' was successfully updated.'
      redirect_to admin_assets_path
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/assets/1
  def destroy
    @asset.destroy
    redirect_to admin_assets_path
  end
  
  protected
  
  def find_asset
    @asset = site.assets.find(params[:id])
  end
end

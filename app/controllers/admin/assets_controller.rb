class Admin::AssetsController < Admin::AdminController

  before_filter :find_asset, :only => [:show, :edit, :update, :destroy]

  # GET /admin/assets
  # GET /admin/assets.xml
  def index
    @assets = @site.assets
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end

  # GET /admin/assets/1
  # GET /admin/assets/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /admin/assets/new
  # GET /admin/assets/new.xml
  def new
    @asset = @site.assets.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /admin/assets/1/edit
  def edit
  end

  # POST /admin/assets
  # POST /admin/assets.xml
  def create
    @asset = @site.assets.build(params[:asset])
    respond_to do |format|
      if @asset.save
        flash[:notice] = 'Asset was successfully created.'
        format.html { redirect_to admin_asset_path(@asset) }
        format.xml  { render :xml => @asset, :status => :created, :location => @asset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/assets/1
  # PUT /admin/assets/1.xml
  def update
    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        flash[:notice] = 'Asset was successfully updated.'
        format.html { redirect_to admin_asset_path(@asset) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/assets/1
  # DELETE /admin/assets/1.xml
  def destroy
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to admin_assets_path }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_asset
    @asset = site.assets.find(params[:id])
  end
end
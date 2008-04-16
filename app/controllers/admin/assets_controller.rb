class Admin::AssetsController < Admin::AdminController
  # GET /admin/assets
  # GET /admin/assets.xml
  def index
    @assets = Asset.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end

  # GET /admin/assets/1
  # GET /admin/assets/1.xml
  def show
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /admin/assets/new
  # GET /admin/assets/new.xml
  def new
    @asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /admin/assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
  end

  # POST /admin/assets
  # POST /admin/assets.xml
  def create
    @asset = Asset.new(params[:asset])

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
    @asset = Asset.find(params[:id])

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
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to admin_assets_path }
      format.xml  { head :ok }
    end
  end
end

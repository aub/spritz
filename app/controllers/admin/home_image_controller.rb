class Admin::HomeImageController < Admin::AdminController
  
  before_filter :find_assets, :only => [:edit]
  
  # GET /admin/home/edit
  def edit
  end

  # PUT /admin/home/home_image
  def update
    unless params[:asset_id].blank?
      @site.assigned_home_image = AssignedAsset.new(:asset_id => params[:asset_id])
      expire_home_page
      flash[:notice] = 'Home was successfully updated.'
      redirect_to edit_admin_home_path
    else
      find_assets
      render :action => "edit"
    end
  end
  
  protected
  
  def find_assets
    @assets = @site.assets.paginate :page => params[:page], :per_page => 18
  end
end
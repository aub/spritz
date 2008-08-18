class Admin::SettingsController < Admin::AdminController

  cache_sweeper :site_sweeper, :only => [:update]
  
  # GET /admin/settings/edit
  def edit
  end
  
  # PUT /admin/settings/
  # PUT /admin/settings
  def update
    if @site.update_attributes(params[:site])
      flash[:notice] = 'Settings were successfully updated.'
      redirect_to admin_path
    else
      render :action => "edit"
    end
  end
end
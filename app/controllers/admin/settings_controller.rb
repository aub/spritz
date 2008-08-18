class Admin::SettingsController < Admin::AdminController

  cache_sweeper :site_sweeper, :only => [:update]
  
  # GET /admin/settings/edit
  def edit
  end
  
  # PUT /admin/settings/
  # PUT /admin/settings
  def update
    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Settings were successfully updated.'
        format.html { redirect_to admin_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end
end
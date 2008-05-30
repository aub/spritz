class Admin::HomeController < Admin::AdminController
  
  # GET /admin/home/edit
  def edit
  end

  # PUT /admin/home/1
  # PUT /admin/home/1.xml
  def update
    respond_to do |format|
      if @site.update_attributes(params[:site])
        expire_home_page
        flash[:notice] = 'Home was successfully updated.'
        format.html { redirect_to edit_admin_home_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end
end
class Admin::HomeController < Admin::AdminController
  
  # GET /admin/home/edit
  def edit
  end
  
  # PUT /links/1
  # PUT /links/1.xml
  def update
    respond_to do |format|
      if @site.update_attributes(params[:site])
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
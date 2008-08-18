class Admin::HomeController < Admin::AdminController
  
  # GET /admin/home/edit
  def edit
  end

  # PUT /admin/home/1
  def update
    if @site.update_attributes(params[:site])
      expire_home_page
      flash[:notice] = 'Home was successfully updated.'
      redirect_to edit_admin_home_path
    else
      render :action => "edit"
    end
  end
end
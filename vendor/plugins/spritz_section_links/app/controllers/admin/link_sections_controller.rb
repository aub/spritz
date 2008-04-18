class Admin::LinkSectionsController < Admin::AdminController
  def show
    @section = @site.sections.find(params[:id])
  end
  
  # DELETE /admin/sites/1
  # DELETE /admin/sites/1.xml
  def destroy
    @section = @site.sections.find(params[:id])
    @section.destroy

    respond_to do |format|
      flash[:notice] = "#{@section.title} was successfully destroyed."
      format.html { redirect_to(admin_sections_path) }
      format.xml  { head :ok }
    end
  end
end
class Admin::PortfolioSectionsController < Admin::AdminController

  before_filter :find_section, :only => [:show, :destroy]

  def show
    redirect_to :controller => 'admin/portfolio_pages', :action => 'edit', :id => @section.portfolio.id, :portfolio_section_id => @section.id
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
  
  protected
  
  def find_section
    @section = @site.sections.find(params[:id])
  end
end
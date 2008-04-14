class Admin::LinkSectionsController < Admin::AdminController
  def edit
    @section = @site.sections.find(params[:id])
  end
end
class Admin::LinkSectionsController < Admin::AdminController
  def show
    @section = @site.sections.find(params[:id])
  end
end
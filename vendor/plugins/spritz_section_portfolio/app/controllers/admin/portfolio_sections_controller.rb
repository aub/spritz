class Admin::PortfolioSectionsController < Admin::AdminController
  def show
    @section = @site.sections.find(params[:id])
  end
end
class Admin::PortfolioSectionsController < Admin::AdminController
  def show
    @section = @site.sections.find(params[:id])
    @portfolio_page = @section.portfolio
  end
end
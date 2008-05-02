module Admin::PortfoliosHelper

  def link_to_new_portfolio
    if (@portfolio)
      link_to "Add New", add_child_admin_portfolio_path(@portfolio)
    else
      link_to "New Portfolio", new_admin_portfolio_path
    end
  end
end

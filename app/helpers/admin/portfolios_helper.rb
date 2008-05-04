module Admin::PortfoliosHelper

  def link_to_new_portfolio
    if (@portfolio)
      link_to "Add New", add_child_admin_portfolio_path(@portfolio)
    else
      link_to "Add New", new_admin_portfolio_path
    end
  end
  
  def ancestor_breadcrumbs(portfolio)
    result = '> ' + link_to('Portfolios', admin_portfolios_path) + ' '
    portfolio.self_and_ancestors.each do |ancestor|
      result << '> '
      result << link_to(ancestor.title, edit_admin_portfolio_path(ancestor))
      result << ' '
    end
    result
  end
end

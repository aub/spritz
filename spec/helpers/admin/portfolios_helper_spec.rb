require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PortfoliosHelper do
  define_models :portfolios_helper do
    model Portfolio do
      stub :one, :title => 'one', :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2
      stub :two, :title => 'two', :site => all_stubs(:site), :parent_id => nil, :lft => 3, :rgt => 4
    end
  end
  
  describe "link_to_new_portfolio method" do
    define_models :portfolios_helper
    
    it "should link to the add child path if there is a portfolio" do
      @portfolio = portfolios(:one)
      link_to_new_portfolio.should == "<a href=\"/admin/portfolios/#{@portfolio.id}/add_child\">Add New</a>"
    end
    
    it "should link to the normal new path if there is not" do
      @portfolio = nil
      link_to_new_portfolio.should == "<a href=\"/admin/portfolios/new\">Add New</a>"
    end
  end
  
  describe "ancestor_breadcrumbs method" do
    define_models :portfolios_helper
    
    it "should return an empty string with no ancestors" do
      ancestor_breadcrumbs(portfolios(:one)).should == ''
    end
    
    it "should return a list of ancestors if there are some" do
      portfolios(:two).move_to_child_of(portfolios(:one))
      ancestor_breadcrumbs(portfolios(:two)).should == '> ' + link_to(portfolios(:one).title, edit_admin_portfolio_path(portfolios(:one))) + ' '
    end
  end
end

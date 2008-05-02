require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PortfoliosHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the Admin::PortfolioHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(Admin::PortfoliosHelper)
  end

  describe "link_to_new_portfolio method" do
    define_models :portfolios_helper do
      model Portfolio do
        stub :one, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2
      end
    end
    
    it "should link to the add child path if there is a portfolio" do
      @portfolio = portfolios(:one)
      link_to_new_portfolio.should == "<a href=\"/admin/portfolios/#{@portfolio.id}/add_child\">Add New</a>"
    end
    
    it "should link to the normal new path if there is not" do
      @portfolio = nil
      link_to_new_portfolio.should == "<a href=\"/admin/portfolios/new\">New Portfolio</a>"
    end
  end
  
end

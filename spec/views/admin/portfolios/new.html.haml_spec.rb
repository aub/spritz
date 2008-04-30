require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/portfolios/new.html.haml" do
  include Admin::PortfoliosHelper
  
  before(:each) do
    @portfolio = mock_model(Portfolio)
    @portfolio.stub!(:new_record?).and_return(true)
    @portfolio.stub!(:site_id).and_return("1")
    @portfolio.stub!(:parent_id).and_return("1")
    @portfolio.stub!(:lft).and_return("1")
    @portfolio.stub!(:rgt).and_return("1")
    @portfolio.stub!(:name).and_return("MyString")
    @portfolio.stub!(:body).and_return("MyText")
    assigns[:portfolio] = @portfolio
  end

  it "should render new form" do
    render "/admin/portfolios/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", admin_portfolios_path) do
      with_tag("input#portfolio_lft[name=?]", "portfolio[lft]")
      with_tag("input#portfolio_rgt[name=?]", "portfolio[rgt]")
      with_tag("input#portfolio_name[name=?]", "portfolio[name]")
      with_tag("textarea#portfolio_body[name=?]", "portfolio[body]")
    end
  end
end



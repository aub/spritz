require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/portfolios/index.html.haml" do
  include Admin::PortfoliosHelper
  
  before(:each) do
    portfolio_98 = mock_model(Portfolio)
    portfolio_98.should_receive(:site_id).and_return("1")
    portfolio_98.should_receive(:parent_id).and_return("1")
    portfolio_98.should_receive(:lft).and_return("1")
    portfolio_98.should_receive(:rgt).and_return("1")
    portfolio_98.should_receive(:name).and_return("MyString")
    portfolio_98.should_receive(:body).and_return("MyText")
    portfolio_99 = mock_model(Portfolio)
    portfolio_99.should_receive(:site_id).and_return("1")
    portfolio_99.should_receive(:parent_id).and_return("1")
    portfolio_99.should_receive(:lft).and_return("1")
    portfolio_99.should_receive(:rgt).and_return("1")
    portfolio_99.should_receive(:name).and_return("MyString")
    portfolio_99.should_receive(:body).and_return("MyText")

    assigns[:portfolios] = [portfolio_98, portfolio_99]
  end

  it "should render list of portfolios" do
    render "/admin/portfolios/index.html.haml"
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyText", 2)
  end
end


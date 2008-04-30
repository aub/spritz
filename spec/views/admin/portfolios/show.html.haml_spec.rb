require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/portfolios/show.html.haml" do
  include Admin::PortfoliosHelper
  
  before(:each) do
    @portfolio = mock_model(Portfolio)
    @portfolio.stub!(:site_id).and_return("1")
    @portfolio.stub!(:parent_id).and_return("1")
    @portfolio.stub!(:lft).and_return("1")
    @portfolio.stub!(:rgt).and_return("1")
    @portfolio.stub!(:name).and_return("MyString")
    @portfolio.stub!(:body).and_return("MyText")

    assigns[:portfolio] = @portfolio
  end

  it "should render attributes in <p>" do
    render "/admin/portfolios/show.html.haml"
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
  end
end


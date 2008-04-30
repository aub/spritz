require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/portfolios/edit.html.haml" do
  include Admin::PortfoliosHelper
  
  before do
    @portfolio = mock_model(Portfolio)
    @portfolio.stub!(:title).and_return("MyString")
    @portfolio.stub!(:body).and_return("MyText")
    @portfolio.stub!(:assigned_assets).and_return([])
    assigns[:portfolio] = @portfolio
    
    @site = mock_model(Site)
    @site.stub!(:assets).and_return([])
    assigns[:site] = @site
  end

  it "should render edit form" do
    render "/admin/portfolios/edit.html.haml"
    
    response.should have_tag("form[action=#{admin_portfolio_path(@portfolio)}][method=post]") do
      with_tag('input#portfolio_title[name=?]', "portfolio[title]")
      with_tag('textarea#portfolio_body[name=?]', "portfolio[body]")
    end
  end
end



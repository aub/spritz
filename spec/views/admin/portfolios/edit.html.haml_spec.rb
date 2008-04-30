require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/portfolios/edit.html.haml" do
  include Admin::PortfoliosHelper
  
  before do
    @portfolio = mock_model(Portfolio)
    @portfolio.stub!(:site_id).and_return("1")
    @portfolio.stub!(:parent_id).and_return("1")
    @portfolio.stub!(:lft).and_return("1")
    @portfolio.stub!(:rgt).and_return("1")
    @portfolio.stub!(:name).and_return("MyString")
    @portfolio.stub!(:body).and_return("MyText")
    assigns[:portfolio] = @portfolio
  end

  it "should render edit form" do
    render "/admin/portfolios/edit.html.haml"
    
    response.should have_tag("form[action=#{admin_portfolio_path(@portfolio)}][method=post]") do
      with_tag('input#portfolio_lft[name=?]', "portfolio[lft]")
      with_tag('input#portfolio_rgt[name=?]', "portfolio[rgt]")
      with_tag('input#portfolio_name[name=?]', "portfolio[name]")
      with_tag('textarea#portfolio_body[name=?]', "portfolio[body]")
    end
  end
end



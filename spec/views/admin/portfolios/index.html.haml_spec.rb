require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/portfolios/index.html.haml" do
  include Admin::PortfoliosHelper
  
  before(:each) do
    portfolio_98 = mock_model(Portfolio)
    portfolio_98.should_receive(:title).and_return("MyString")
    portfolio_99 = mock_model(Portfolio)
    portfolio_99.should_receive(:title).and_return("MyString")

    assigns[:portfolios] = [portfolio_98, portfolio_99]
  end

  it "should render list of portfolios" do
    render "/admin/portfolios/index.html.haml"
  end
end


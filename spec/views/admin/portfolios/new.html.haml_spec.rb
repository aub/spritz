require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/portfolios/new.html.haml" do
  include Admin::PortfoliosHelper
  
  before(:each) do
    @cover_image = mock_model(Paperclip::Attachment, :file? => false)
    
    @portfolio = mock_model(Portfolio)
    @portfolio.stub!(:new_record?).and_return(true)
    @portfolio.stub!(:site_id).and_return("1")
    @portfolio.stub!(:parent_id).and_return("1")
    @portfolio.stub!(:lft).and_return("1")
    @portfolio.stub!(:rgt).and_return("1")
    @portfolio.stub!(:title).and_return("MyString")
    @portfolio.stub!(:body).and_return("MyText")
    @portfolio.stub!(:cover_image).and_return(@cover_image)
    assigns[:portfolio] = @portfolio
  end

  it "should render new form" do
    render "/admin/portfolios/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", admin_portfolios_path) do
      with_tag("input#portfolio_title[name=?]", "portfolio[title]")
      with_tag("textarea#portfolio_body[name=?]", "portfolio[body]")
    end
  end
end



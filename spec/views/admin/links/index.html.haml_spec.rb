require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/links/index.html.haml" do
  include Admin::LinksHelper
  
  before(:each) do
    link_98 = mock_model(Link)
    link_98.should_receive(:url).and_return("MyString")
    link_98.should_receive(:title).and_return("MyString")
    link_99 = mock_model(Link)
    link_99.should_receive(:url).and_return("MyString")
    link_99.should_receive(:title).and_return("MyString")

    assigns[:links] = [link_98, link_99]
  end

  it "should render list of links" do
    render "/admin/links/index.html.haml"
    response.should be_success
  end
end


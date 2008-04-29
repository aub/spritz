require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/links/show.html.haml" do
  include Admin::LinksHelper
  
  before(:each) do
    @link = mock_model(Link)
    @link.stub!(:url).and_return("MyString")
    @link.stub!(:title).and_return("MyString")

    assigns[:link] = @link
  end

  it "should render attributes in <p>" do
    render "/admin/links/show.html.haml"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end


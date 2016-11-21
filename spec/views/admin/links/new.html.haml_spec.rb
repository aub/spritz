require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/links/new.html.haml" do
  include Admin::LinksHelper
  
  before(:each) do
    @link = mock_model(Link)
    @link.stub!(:new_record?).and_return(true)
    @link.stub!(:url).and_return("MyString")
    @link.stub!(:title).and_return("MyString")
    assigns[:link] = @link
  end

  it "should render new form" do
    render "/admin/links/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", admin_links_path) do
      with_tag("input#link_url[name=?]", "link[url]")
      with_tag("input#link_title[name=?]", "link[title]")
    end
  end
end



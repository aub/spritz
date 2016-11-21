require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/links/edit.html.haml" do
  include Admin::LinksHelper
  
  before do
    @link = mock_model(Link)
    @link.stub!(:url).and_return("MyString")
    @link.stub!(:title).and_return("MyString")
    assigns[:link] = @link
  end

  it "should render edit form" do
    render "/admin/links/edit.html.haml"
    
    response.should have_tag("form[action=#{admin_link_path(@link)}][method=post]") do
      with_tag('input#link_url[name=?]', "link[url]")
      with_tag('input#link_title[name=?]', "link[title]")
    end
  end
end



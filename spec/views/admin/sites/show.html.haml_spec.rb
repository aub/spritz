require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sites/show.html.haml" do
  include Admin::SitesHelper
  
  before(:each) do
    @site = mock_model(Site)
    @site.stub!(:domain).and_return("MyString")
    @site.stub!(:subdomain).and_return("MyString")

    assigns[:template_site] = @site
  end

  it "should render attributes in <p>" do
    render "/admin/sites/show.html.haml"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end


require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sites/edit.html.haml" do
  include Admin::SitesHelper
  
  before do
    @site = mock_model(Site)
    @site.stub!(:domain).and_return("MyString")
    @site.stub!(:subdomain).and_return("MyString")
    @site.stub!(:title).and_return('title')
    @site.stub!(:google_analytics_code).and_return('ack')
    assigns[:template_site] = @site
  end

  it "should render edit form" do
    render "/admin/sites/edit.html.haml"
    
    response.should have_tag("form[action=#{admin_site_path(@site)}][method=post]") do
    end
  end
end



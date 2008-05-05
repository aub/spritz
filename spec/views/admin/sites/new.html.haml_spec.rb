require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sites/new.html.erb" do
  include Admin::SitesHelper
  
  before(:each) do
    @site = mock_model(Site)
    @site.stub!(:new_record?).and_return(true)
    @site.stub!(:domain).and_return("MyString")
    @site.stub!(:subdomain).and_return("MyString")
    @site.stub!(:title).and_return('title')
    assigns[:template_site] = @site
  end

  it "should render new form" do
    render "/admin/sites/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", admin_sites_path) do
      with_tag("input#site_domain[name=?]", "site[domain]")
      with_tag("input#site_subdomain[name=?]", "site[subdomain]")
    end
  end
end



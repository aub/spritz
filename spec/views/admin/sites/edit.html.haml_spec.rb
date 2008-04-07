require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sites/edit.html.haml" do
  include Admin::SitesHelper
  
  before do
    @site = mock_model(Site)
    @site.stub!(:domain).and_return("MyString")
    @site.stub!(:subdomain).and_return("MyString")
    assigns[:site] = @site
  end

  it "should render edit form" do
    render "/admin/sites/edit.html.haml"
    
    response.should have_tag("form[action=#{admin_site_path(@site)}][method=post]") do
      with_tag('input#site_domain[name=?]', "site[domain]")
      with_tag('input#site_subdomain[name=?]', "site[subdomain]")
    end
  end
end



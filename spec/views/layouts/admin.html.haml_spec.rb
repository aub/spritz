require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/admin.html.haml" do

  define_models


  before(:each) do
    assigns[:site] = sites(:default)
    login_as :admin
    render "/layouts/admin.html.haml"
  end
  
  it "should work" do
    response.should be_success
  end
  
  it "should contain a link for logging out" do
    response.should have_tag("a[href=?]", admin_session_path)
  end
  
  it "should contain a link for the dashboard" do
    response.should have_tag("a[href=?]", dashboard_path)
  end
  
  it "should have a link to the settings page" do
    response.should have_tag("a[href=?]", edit_admin_settings_path)
  end
  
  it "should contain a link to the sections list" do
    response.should have_tag("a[href=?]", admin_sections_path)
  end
  
  it "should contain a link to the assets page" do
    response.should have_tag("a[href=?]", admin_assets_path)
  end
end
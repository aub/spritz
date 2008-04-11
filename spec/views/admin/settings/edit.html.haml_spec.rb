require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/settings/edit.html.haml" do
  include Admin::SettingsHelper
  
  define_models
  
  before(:each) do
    assigns[:site] = sites(:default)
    render "/admin/settings/edit.html.haml"
  end

  it "should have a form for the site" do
    response.should have_tag('form[method=post][action=?]', admin_settings_path)
  end
  
end
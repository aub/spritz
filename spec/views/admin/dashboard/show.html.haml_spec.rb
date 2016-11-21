require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/dashboard/show.html.haml" do
  include Admin::DashboardHelper
  
  define_models :show
  
  before(:each) do
    assigns[:site] = sites(:default)
  end

  it "should be successful" do
    render "/admin/dashboard/show.html.haml"
    response.should be_success
  end
end


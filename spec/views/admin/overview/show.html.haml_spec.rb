require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/overview/show.html.haml" do
  include Admin::OverviewHelper
  
  before(:each) do
  end

  it "should be successful" do
    render "/admin/overview/show.html.haml"
    response.should be_success
  end
end


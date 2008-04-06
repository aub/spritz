require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sessions/new.html.haml" do
  include Admin::SessionsHelper
  
  before(:each) do
    render "/admin/sessions/new.html.haml"
  end

  it "should render the new session form" do
    # just make sure it works
  end
  
  
end
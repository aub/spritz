require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/admin.html.haml" do

  define_models

  def render_layout(user)
    login_as user if user
    render "/layouts/admin.html.haml"
  end
  
  it "should work" do
    render_layout :admin
    response.should be_success
  end
  
  it "should contain a link for logging out" do
    render_layout :admin
    response.should have_tag("a[href=?]", admin_session_path)
  end
end
require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/users/new.html.haml" do
  include Admin::UsersHelper
  
  before(:each) do
    @user = mock_model(User, :login => 'l', :email => 'e', :password => 'p', :password_confirmation => 'pc')
    assigns[:user] = @user
    
    render "/admin/users/new.html.haml"
  end

  it "should render the new user form" do
    # just make sure it works
  end
  
  
end
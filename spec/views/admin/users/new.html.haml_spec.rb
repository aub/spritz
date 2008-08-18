require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/users/new.html.haml" do
  include Admin::UsersHelper
  
  before(:each) do
    @user = mock_model(User, :login => 'l', :email => 'e', :password => 'p', :password_confirmation => 'pc', :admin => false)
    assigns[:user] = @user    
  end

  def do_render
    render "/admin/users/new.html.haml"
  end

  it "should render the new user form" do
    do_render
  end
  
  it "should not include a checkbox for admin unless the user is an admin" do
    template.stub!(:admin?).and_return(false)
    do_render
    response.should_not have_tag('input[name=?]', 'user[admin]')
  end
  
  it "should include a checkbox for admin if the logged in user is admin and not the one being edited" do
    template.stub!(:current_user).and_return(mock_model(User))
    template.stub!(:admin?).and_return(true)
    do_render
    response.should have_tag('input[name=?]', 'user[admin]')
  end
  
  it "should not allow the user to change their own admin status" do
    template.stub!(:current_user).and_return(@user)
    template.stub!(:admin?).and_return(true)
    do_render
    response.should_not have_tag('input[name=?]', 'user[admin]')
  end
  
  it "should indicate that the user is admin if it is the current user and admin" do
    template.stub!(:current_user).and_return(@user)
    template.stub!(:admin?).and_return(true)
    do_render
    response.should have_tag('h3', :text => 'You are an administrator')    
  end
end
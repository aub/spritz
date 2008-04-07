require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SessionsController do

  define_models :sessions_controller

  before(:each) do
    activate_site(:default)
  end

  it 'logins and redirects' do
    post :create, :login => 'admin', :password => 'test'
    session[:user_id].should_not be_nil
    response.should redirect_to(overview_path)
  end
  
  it 'fails login and does not redirect' do
    post :create, :login => 'admin', :password => 'bad password'
    session[:user_id].should be_nil
    response.should be_success
  end

  it 'logs out' do
    login_as :admin
    get :destroy
    session[:user_id].should be_nil
    response.should be_redirect
  end

  it 'remembers me' do
    post :create, :login => 'admin', :password => 'test', :remember_me => "1"
    response.cookies["auth_token"].should_not be_nil
  end
  
  it 'does not remember me' do
    post :create, :login => 'admin', :password => 'test', :remember_me => "0"
    response.cookies["auth_token"].should be_nil
  end

  it 'deletes token on logout' do
    login_as :admin
    get :destroy
    response.cookies["auth_token"].should == []
  end

  it 'logs in with cookie' do
    users(:admin).remember_me
    request.cookies["auth_token"] = cookie_for(:admin)
    get :new
    controller.send(:logged_in?).should be_true
  end
  
  it 'fails expired cookie login' do
    users(:admin).remember_me
    users(:admin).update_attribute :remember_token_expires_at, 5.minutes.ago.utc
    request.cookies["auth_token"] = cookie_for(:admin)
    get :new
    controller.send(:logged_in?).should_not be_true
  end
  
  it 'fails cookie login' do
    users(:admin).remember_me
    request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    controller.send(:logged_in?).should_not be_true
  end

  describe "site, login, and admin requirements" do
    define_models :sessions_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :new },
        lambda { post :create },
        lambda { delete :destroy, :id => 1 }])
    end
        
    it "should not require login" do
      test_login_requirement(false, false, [
        lambda { get :new },
        lambda { post :create },
        lambda { delete :destroy, :id => 1 }])
    end
  end

  protected

  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(user)
    auth_token users(user).remember_token
  end
end

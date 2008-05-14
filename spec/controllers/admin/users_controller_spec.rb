require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController do

  define_models :users_controller

  before(:each) do
    login_as(:admin)
    activate_site(:default)
  end

  it 'allows signup' do
    lambda do
      create_user
      response.should be_redirect      
    end.should change(User, :count).by(1)
  end

  
  it 'signs up user in active state' do
    create_user
    assigns(:user).should be_active
  end

  
  it 'signs up user with activation code' do
    create_user
    assigns(:user).activation_code.should be_nil
  end

  it 'requires login on signup' do
    lambda do
      create_user(:login => nil)
      assigns[:user].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_user(:password => nil)
      assigns[:user].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_user(:password_confirmation => nil)
      assigns[:user].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_user(:email => nil)
      assigns[:user].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(User, :count)
  end
  
  it 'activates user' do
    User.authenticate_for(sites(:default), 'unactivated', 'test').should be_nil
    get :activate, :activation_code => users(:unactivated).activation_code
    response.should redirect_to('/')
    flash[:notice].should_not be_nil
    users(:unactivated).reload
    User.authenticate_for(sites(:default), 'unactivated', 'test').should == users(:unactivated)
  end
  
  it 'does not activate user with blank key' do
    get :activate, :activation_code => ''
    flash[:notice].should be_nil
  end
  
  describe "handling suspend, unsuspend, destroy, and purge" do
    define_models :users_controller

    it "should suspend a user" do
      put :suspend, :id => users(:nonadmin).id
      users(:nonadmin).reload.state.should == 'suspended'
    end

    it "should redirect to admin_users_path on suspend" do
      put :suspend, :id => users(:nonadmin).id
      response.should redirect_to(admin_users_path)
    end
    
    it "should unsuspend a user" do
      users(:nonadmin).suspend!
      put :unsuspend, :id => users(:nonadmin).id
      users(:nonadmin).reload.state.should == 'active'
    end
    
    it "should redirect to admin_users_path on unsuspend" do
      put :unsuspend, :id => users(:nonadmin).id
      response.should redirect_to(admin_users_path)
    end
    
    it "should destroy a user" do
      delete :destroy, :id => users(:nonadmin).id
      users(:nonadmin).reload.state.should == 'deleted'      
    end
    
    it "should only change the state on delete, not actually remove the user" do
      lambda { delete :destroy, :id => users(:nonadmin).id }.should_not change(User, :count)
    end

    it "should redirect to admin_users_path on destroy" do
      delete :destroy, :id => users(:nonadmin).id
      response.should redirect_to(admin_users_path)
    end

    it "should purge a user by actually deleting it" do
      lambda { delete :purge, :id => users(:nonadmin).id }.should change(User, :count).by(-1)
    end

    it "should redirect to admin_users_path on purge" do
      delete :purge, :id => users(:nonadmin).id
      response.should redirect_to(admin_users_path)
    end
  end
  
  describe "handling GET /admin/users/1/edit" do
    define_models :users_controller
    
    before(:each) do
      login_as(:admin)
    end
    
    def do_get
      get :edit, :id => users(:admin).id
    end
    
    it "should assign the user for the view" do
      do_get
      assigns[:user].should == users(:admin)
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template('edit')
    end
  end
  
  describe "handling PUT admin/users/1" do
    define_models :users_controller

    before(:each) do
      login_as(:admin)
    end

    describe "with successful update" do
      define_models :users_controller
      
      def do_put
        put :update, :id => users(:admin).id, :user => { :password => 'booya', :password_confirmation => 'booya' }
      end

      it "should update the found user" do
        do_put
        users(:admin).reload
        User.authenticate_for(sites(:default), 'admin', 'booya').should == users(:admin)
      end

      it "should assign the found user for the view" do
        do_put
        assigns(:user).should == users(:admin)
      end

      it "should redirect to the dashboard" do
        do_put
        response.should redirect_to(admin_path)
      end
    end
    
    describe "with failed update" do
      define_models :users_controller
      
      def do_put
        put :update, :id => users(:admin).id, :user => { :password => 'abcdefg', :password_confirmation => 'hijklmnop' }
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
    end
  end
  
  describe "handling GET /admin/users/forgot_password" do
    define_models :users_controller
    
    before(:each) do
      login_as(:admin)
    end
    
    def do_get
      get :forgot_password
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render the forgot_password template" do
      do_get
      response.should render_template('forgot_password')
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :users_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :new },
        lambda { get :edit, :id => users(:nonadmin).id },
        lambda { get :activate, :id => users(:nonadmin).id },
        lambda { put :suspend, :id => users(:nonadmin).id },
        lambda { put :unsuspend, :id => users(:nonadmin).id },
        lambda { post :create },
        lambda { delete :purge, :id => users(:nonadmin).id },
        lambda { delete :destroy, :id => users(:nonadmin).id },
        lambda { get :forgot_password },
        lambda { put :reset_password }])
    end
    
    it "should require admin login" do
      test_login_requirement(true, true, [
        lambda { put :suspend, :id => users(:nonadmin).id },
        lambda { put :unsuspend, :id => users(:nonadmin).id },
        lambda { delete :purge, :id => users(:nonadmin).id },
        lambda { delete :destroy, :id => users(:nonadmin).id }])
    end

    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :edit, :id => users(:nonadmin).id },
        lambda { put :update, :id => users(:nonadmin).id }])
    end
    
    it "should not require login" do
      test_login_requirement(false, false, [
        lambda { get :new },
        lambda { post :create },
        lambda { get :activate, :id => users(:nonadmin).id },
        lambda { get :forgot_password },
        lambda { put :reset_password }])
    end
    
    it "should not allow editing of some other user" do
      login_as(:nonadmin)
      get :edit, :id => users(:admin).id
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should not allow updating of some other user" do
      login_as(:nonadmin)
      put :update, :id => users(:admin).id, :user => { :password => 'abcdef', :password_confirmation => 'abcdef' }
      response.should redirect_to(new_admin_session_path)
    end
    
    it "should allow admin to edit other users" do
      login_as(:admin)
      get :edit, :id => users(:nonadmin).id
      response.should be_success
    end
    
    it "should allow admin to update other users" do
      login_as(:admin)
      put :update, :id => users(:nonadmin).id, :user => { :password => 'abcdef', :password_confirmation => 'abcdef' }
      response.should_not redirect_to(new_admin_session_path)
    end
  end
  
  protected
  
  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
end
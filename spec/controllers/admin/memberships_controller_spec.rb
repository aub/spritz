require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::MembershipsController do
  define_models :memberships_controller do
  end
  
  before(:each) do
    activate_site(:default)
  end
  
  describe "GET /users/1/memberships" do
    define_models :memberships_controller
    
    before(:each) do
      login_as :admin
    end
    
    def do_get
      get :index, :user_id => users(:nonadmin).id
    end
    
    it "should be sucessful" do
      do_get
      response.should be_success
    end
    
    it "should render the index template" do
      do_get
      response.should render_template('index')
    end
    
    it "should assign the list of memberships for this user" do
      do_get
      assigns[:memberships].should == users(:nonadmin).memberships
    end
    
    it "should assign the user to the view" do
      do_get
      assigns[:user].should == users(:nonadmin)
    end
  end
  
  describe "GET /users/1/memberships/new" do
    define_models :memberships_controller
    
    before(:each) do
      login_as :admin
    end
    
    def do_get
      get :new, :user_id => users(:nonadmin).id
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render the new template" do
      do_get
      response.should render_template('new')
    end
    
    it "should assign the user to the view" do
      do_get
      assigns[:user].should == users(:nonadmin)
    end
    
    it "should assign a membership with the assigned user to the view" do
      do_get
      assigns[:membership].should_not be_nil
      assigns[:membership].user_id.should == users(:nonadmin).id
    end
    
    it "should assign the list of sites that the user is not a member of to the view" do
      do_get
      assigns[:sites].should == Site.find(:all) - users(:nonadmin).sites
    end
  end
  
  describe "handling POST /users/1/memberships" do
    define_models :memberships_controller
    
    before(:each) do
      login_as :admin
      users(:nonadmin).sites.include?(sites(:other)).should be_false
    end
    
    def do_post
      post :create, :user_id => users(:nonadmin), :membership => { :user_id => users(:nonadmin).id, :site_id => sites(:other).to_param }
    end
    
    it "should create a new membership for the user" do
      do_post
      users(:nonadmin).sites.reload.include?(sites(:other)).should be_true
    end
    
    it "should redirect to the membership list" do
      do_post
      response.should redirect_to(admin_user_memberships_path(users(:nonadmin)))
    end
    
    describe "with failed save" do
      define_models :memberships_controller
      
      def do_post
        post :create, :user_id => users(:nonadmin), :membership => { :user_id => users(:nonadmin).id, :site_id => sites(:default).to_param }
      end
      
      it "should not create a membership" do
        lambda { do_post }.should_not change(Membership, :count)
      end
      
      it "should rerender the new template" do
        do_post
        response.should render_template('new')
      end
      
      it "should assign the failed membership for the view" do
        do_post
        assigns[:membership].should_not be_nil
        assigns[:membership].user_id.should == users(:nonadmin).id
      end
    end
  end
  
  describe "handling DELETE /users/1/memberships/1/destroy" do
    define_models :memberships_controller
    
    before(:each) do
      login_as :admin
      users(:nonadmin).sites.include?(sites(:default)).should be_true
    end

    def do_delete
      delete :destroy, :user_id => users(:nonadmin).id, :id => memberships(:nonadmin_on_default).id
    end
    
    it "should destroy the membership" do
      do_delete
      users(:nonadmin).sites.reload.include?(sites(:default)).should be_false
    end
    
    it "should redirect to the list of memberships for the user" do
      do_delete
      response.should redirect_to(admin_user_memberships_path(users(:nonadmin)))
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :memberships_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index, :user_id => users(:nonadmin) },
        lambda { get :new, :user_id => users(:nonadmin) },
        lambda { post :create, :membership => {}, :user_id => users(:nonadmin) },
        lambda { delete :destroy, :id => memberships(:admin_on_default).id, :user_id => users(:nonadmin) }])
    end
    
    it "should require normal login" do
      test_login_requirement(true, true, [
        lambda { get :index, :user_id => users(:nonadmin) },
        lambda { get :new, :user_id => users(:nonadmin) },
        lambda { post :create, :membership => {}, :user_id => users(:nonadmin) },
        lambda { delete :destroy, :id => memberships(:admin_on_default).id, :user_id => users(:nonadmin) }])
    end
  end  
end

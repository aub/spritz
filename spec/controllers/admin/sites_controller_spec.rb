require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SitesController do

  define_models :sites_controller
  
  before(:each) do
    @active_site = mock_model(Site, :domain => 'www.booya.com', :page_cache_path => 'tmp/cache/mock')
    activate_site(@active_site)
    login_as(:admin)
  end

  describe "handling GET /admin/sites" do
    define_models :sites_controller

    before(:each) do
    end
  
    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should find all sites" do
      Site.should_receive(:find).with(:all).and_return([@site])
      do_get
    end
  
    it "should assign the found sites for the view" do
      do_get
      assigns[:sites].should == Site.find(:all)
    end
  end

  describe "handling GET /admin/sites.xml" do
    define_models :sites_controller
    
    before(:each) do
      @site = mock_model(Site, :to_xml => "XML")
      Site.stub!(:find).and_return(@site)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all sites" do
      Site.should_receive(:find).with(:all).and_return([@site])
      do_get
    end
  
    it "should render the found sites as xml" do
      @site.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /admin/sites/new" do
    define_models :sites_controller
    
    before(:each) do
      @site = mock_model(Site)
      Site.stub!(:new).and_return(@site)
      @user = mock_model(User)
      User.stub!(:new).and_return(@user)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new site" do
      Site.should_receive(:new).and_return(@site)
      do_get
    end
  
    it "should not save the new site" do
      @site.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new site for the view" do
      do_get
      assigns[:template_site].should equal(@site)
    end
    
    it "should assign a new user for the view" do
      do_get
      assigns[:user].should equal(@user)
    end
  end

  describe "handling GET /admin/sites/1/edit" do
    define_models :sites_controller
    
    before(:each) do
      @site = mock_model(Site)
      Site.stub!(:find).and_return(@site)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the site requested" do
      Site.should_receive(:find).and_return(@site)
      do_get
    end
  
    it "should assign the found Site for the view" do
      do_get
      assigns[:template_site].should equal(@site)
    end
  end

  describe "handling POST /admin/sites" do
    define_models :sites_controller
    
    before(:each) do
      @site = mock_model(Site, :to_param => '1', :title => 't')
      @site.stub!(:members).and_return([])
      Site.stub!(:new).and_return(@site)

      @user = mock_model(User)
      User.stub!(:new).and_return(@user)
      @user.stub!(:valid?).and_return(true)
      @user.stub!(:admin=)
      @user.stub!(:register!)
      @user.stub!(:activate!)
    end
    
    describe "with successful save" do
      define_models :sites_controller
      
      def do_post
        @site.should_receive(:save).and_return(true)
        @user.should_receive(:save).and_return(true)
        post :create, :site => {}, :user => {}
      end
  
      it "should create a new site" do
        Site.should_receive(:new).with({}).and_return(@site)
        do_post
      end

      it "should redirect to the new site" do
        do_post
        response.should redirect_to(admin_dashboard_path)
      end
      
      it "should create a new user" do
        User.should_receive(:new).with({}).and_return(@user)
        do_post
      end
      
      it "should log the user in" do
        request.session[:user_id] = nil
        do_post
        request.session[:user_id].should == assigns[:user].id
      end
    end
    
    describe "with failed save" do
      define_models :sites_controller
      
      def do_post
        @site.should_receive(:save).and_return(false)
        post :create, :site => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /admin/sites/1" do
    define_models :sites_controller
    
    before(:each) do
      @site = mock_model(Site, :to_param => "1")
      Site.stub!(:find).and_return(@site)
    end
    
    describe "with successful update" do
      define_models :sites_controller
      
      def do_put
        @site.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the site requested" do
        Site.should_receive(:find).with("1").and_return(@site)
        do_put
      end

      it "should update the found site" do
        do_put
        assigns(:template_site).should equal(@site)
      end

      it "should assign the found site for the view" do
        do_put
        assigns(:template_site).should equal(@site)
      end

      it "should redirect to the home page" do
        do_put
        response.should redirect_to(admin_path)
      end

    end
    
    describe "with failed update" do
      define_models :sites_controller
      
      def do_put
        @site.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
    end
  end

  describe "handling DELETE /admin/sites/1" do
    define_models :sites_controller
    
    before(:each) do
      @site = mock_model(Site, :destroy => true)
      Site.stub!(:find).and_return(@site)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the site requested" do
      Site.should_receive(:find).with("1").and_return(@site)
      do_delete
    end
  
    it "should call destroy on the found site" do
      @site.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the sites list" do
      do_delete
      response.should redirect_to(admin_sites_url)
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :sites_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { get :show, :id => sites(:default).id },
        lambda { get :edit, :id => sites(:default).id },
        lambda { put :update, :id => sites(:default).id, :site => {} },
        lambda { delete :destroy, :id => sites(:default).id }])
    end
    
    it "should not require a site" do
      test_site_requirement(false, [
        lambda { get :new },
        lambda { post :create, :site => {} }])
    end
    
    it "should require admin login" do
      test_login_requirement(true, true, [
        lambda { get :index },
        lambda { get :show, :id => sites(:default).id },
        lambda { get :edit, :id => sites(:default).id },
        lambda { put :update, :id => sites(:default).id, :site => {} },
        lambda { delete :destroy, :id => sites(:default).id }])
    end
        
    it "should not require login" do
      test_login_requirement(false, false, [
        lambda { get :new },
        lambda { post :create, :site => {} }])
    end
  end
end
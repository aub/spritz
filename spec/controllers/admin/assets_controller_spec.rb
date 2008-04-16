require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AssetsController do
  define_models :assets_controller
  
  before(:each) do
    activate_site :default
    login_as :admin
  end
  
  describe "handling GET /admin/assets" do
    define_models :assets_controller
    
    before(:each) do
      @asset = mock_model(Asset)
      Asset.stub!(:find).and_return([@asset])
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
  
    it "should find all admin/assets" do
      Asset.should_receive(:find).with(:all).and_return([@asset])
      do_get
    end
  
    it "should assign the found admin/assets for the view" do
      do_get
      assigns[:assets].should == [@asset]
    end
  end

  describe "handling GET /admin/assets.xml" do
    define_models :assets_controller
    
    before(:each) do
      @asset = mock_model(Asset, :to_xml => "XML")
      Asset.stub!(:find).and_return(@asset)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all admin/assets" do
      Asset.should_receive(:find).with(:all).and_return([@asset])
      do_get
    end
  
    it "should render the found admin/assets as xml" do
      @asset.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /admin/assets/1" do
    define_models :assets_controller
    
    before(:each) do
      @asset = mock_model(Asset)
      Asset.stub!(:find).and_return(@asset)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the asset requested" do
      Asset.should_receive(:find).with("1").and_return(@asset)
      do_get
    end
  
    it "should assign the found asset for the view" do
      do_get
      assigns[:asset].should equal(@asset)
    end
  end

  describe "handling GET /admin/assets/1.xml" do
    define_models :assets_controller
    
    before(:each) do
      @asset = mock_model(Asset, :to_xml => "XML")
      Asset.stub!(:find).and_return(@asset)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the asset requested" do
      Asset.should_receive(:find).with("1").and_return(@asset)
      do_get
    end
  
    it "should render the found asset as xml" do
      @asset.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /admin/assets/new" do
    define_models :assets_controller
    
    before(:each) do
      @asset = mock_model(Asset)
      Asset.stub!(:new).and_return(@asset)
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
  
    it "should create an new asset" do
      Asset.should_receive(:new).and_return(@asset)
      do_get
    end
  
    it "should not save the new asset" do
      @asset.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new asset for the view" do
      do_get
      assigns[:asset].should equal(@asset)
    end
  end

  describe "handling GET /admin/assets/1/edit" do
    define_models :assets_controller
    
    before(:each) do
      @asset = mock_model(Asset)
      Asset.stub!(:find).and_return(@asset)
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
  
    it "should find the asset requested" do
      Asset.should_receive(:find).and_return(@asset)
      do_get
    end
  
    it "should assign the found Asset for the view" do
      do_get
      assigns[:asset].should equal(@asset)
    end
  end

  describe "handling POST /admin/assets" do
    define_models :assets_controller
    
    before(:each) do
      @asset = mock_model(Asset, :to_param => "1")
      Asset.stub!(:new).and_return(@asset)
    end
    
    describe "with successful save" do
      define_models :assets_controller
      
      def do_post
        @asset.should_receive(:save).and_return(true)
        post :create, :asset => {}
      end
  
      it "should create a new asset" do
        Asset.should_receive(:new).with({}).and_return(@asset)
        do_post
      end

      it "should redirect to the new asset" do
        do_post
        response.should redirect_to(admin_asset_url("1"))
      end
      
    end
    
    describe "with failed save" do
      define_models :assets_controller
      
      def do_post
        @asset.should_receive(:save).and_return(false)
        post :create, :asset => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /admin/assets/1" do
    define_models :assets_controller
    
    before(:each) do
      @asset = mock_model(Asset, :to_param => "1")
      Asset.stub!(:find).and_return(@asset)
    end
    
    describe "with successful update" do
      define_models :assets_controller
      
      def do_put
        @asset.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the asset requested" do
        Asset.should_receive(:find).with("1").and_return(@asset)
        do_put
      end

      it "should update the found asset" do
        do_put
        assigns(:asset).should equal(@asset)
      end

      it "should assign the found asset for the view" do
        do_put
        assigns(:asset).should equal(@asset)
      end

      it "should redirect to the asset" do
        do_put
        response.should redirect_to(admin_asset_url("1"))
      end

    end
    
    describe "with failed update" do
      define_models :assets_controller
      
      def do_put
        @asset.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /admin/assets/1" do
    define_models :assets_controller
    
    before(:each) do
      @asset = mock_model(Asset, :destroy => true)
      Asset.stub!(:find).and_return(@asset)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the asset requested" do
      Asset.should_receive(:find).with("1").and_return(@asset)
      do_delete
    end
  
    it "should call destroy on the found asset" do
      @asset.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the admin/assets list" do
      do_delete
      response.should redirect_to(admin_assets_url)
    end
  end
  
  describe "admin, login, and site requirements" do
    define_models :assets_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { get :show, :id => 1 },
        lambda { get :edit, :id => 1 },
        lambda { get :new },
        lambda { put :update, :id => 1 },
        lambda { post :create },
        lambda { delete :destroy, :id => 1 }])
    end
        
    it "should require login" do
      test_login_requirement(true, false, [
        lambda { get :index },
        lambda { get :show, :id => 1 },
        lambda { get :edit, :id => 1 },
        lambda { get :new },
        lambda { put :update, :id => 1 },
        lambda { post :create },
        lambda { delete :destroy, :id => 1 }])
    end
  end
  
end
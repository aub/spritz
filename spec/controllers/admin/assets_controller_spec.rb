require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AssetsController do
  define_models :assets_controller do
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'booya'
      stub :two, :site => all_stubs(:site), :filename => 'hooya'
    end
  end
  
  before(:each) do
    activate_site :default
    login_as :admin
  end
  
  describe "handling GET /admin/assets" do
    define_models :assets_controller
    
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
  
    it "should assign the found admin/assets for the view" do
      do_get
      assigns[:assets].sort_by(&:id).should == sites(:default).assets.sort_by(&:id)
    end
  end

  describe "handling GET /admin/assets.xml" do
    define_models :assets_controller
      
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the found admin/assets as xml" do
      do_get
      response.body.should == sites(:default).assets.to_xml
    end
  end

  describe "handling GET /admin/assets/1" do
    define_models :assets_controller
    
    def do_get
      get :show, :id => assets(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
    
    it "should assign the found asset for the view" do
      do_get
      assigns[:asset].should == assets(:one)
    end
  end

  describe "handling GET /admin/assets/1.xml" do
    define_models :assets_controller
    
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => assets(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render the found asset as xml" do
      do_get
      response.body.should == assets(:one).to_xml
    end
  end

  describe "handling GET /admin/assets/new" do
    define_models :assets_controller
    
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
    
    it "should assign the new asset for the view" do
      do_get
      assigns[:asset].should be_an_instance_of(Asset)
    end
    
    it "should not save the new asset" do
      do_get
      assigns[:asset].should be_new_record
    end
  end

  describe "handling GET /admin/assets/1/edit" do
    define_models :assets_controller
    
    def do_get
      get :edit, :id => assets(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should assign the found Asset for the view" do
      do_get
      assigns[:asset].should == assets(:one)
    end
  end

  describe "handling POST /admin/assets" do
    define_models :assets_controller
    
    describe "with successful save" do
      define_models :assets_controller
      
      def do_post
        post :create, :asset => {}
      end
  
      it "should create a new asset" do
        sites(:default).assets.should_receive(:build).with({}).and_return(assets(:two))
        do_post
      end
    end
    
    describe "with failed save" do
      define_models :assets_controller
      
      def do_post
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
    
    def do_delete
      delete :destroy, :id => assets(:one).id
    end

    it "should call destroy on the found asset" do
      do_delete
      Asset.find(:all).detect { |a| a == assets(:one) }.should be_nil
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
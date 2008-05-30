require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ThemesController do
  define_models :themes_controller

  before(:all) do
    cleanup_theme_directory
    Theme.create_defaults_for(sites(:default))
  end
  
  before(:each) do
    activate_site(:default)

    # Create a few cache items.
    @a = CacheItem.for(sites(:default), 'a', [sites(:default)])
    @b = CacheItem.for(sites(:default), 'b', [sites(:default).news_items])
  end
  
  after(:all) do
    cleanup_theme_directory
  end

  describe "handling GET /admin/themes" do
    define_models :themes_controller
    
    before(:each) do
      login_as(:admin)
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
  
    it "should assign the found themes for the view" do
      do_get
      assigns[:themes].should eql(sites(:default).themes)
    end
  end
  
  describe "handling GET /admin/themes/new" do
    define_models :themes_controller
    
    before(:each) do
      login_as(:admin)
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
  end
  
  describe "handling POST /admin/themes" do
    define_models :themes_controller
    
    before(:each) do
      login_as(:admin)
      Theme.stub!(:create_from_zip_data).and_return(true)
    end
    
    def do_post
      post :create, :zip_data => '123'
    end
  
    it "should redirect to the theme list" do
      do_post
      response.should redirect_to(admin_themes_path)
    end
  
    it "should assign the zip data to the theme" do
      Theme.stub!(:new).and_return(@theme)
      Theme.should_receive(:create_from_zip_data).with('123', sites(:default)).and_return(true)
      do_post
    end
  end
  
  describe "handling GET /admin/themes/1/preview" do
    define_models :themes_controller
    
    before(:each) do
      login_as(:admin)
    end
    
    def do_get
      get :preview, :id => 'dark'
    end
    
    it "should render not found if there is no theme/preview" do
      get :preview, :id => 'nope'
      response.should be_missing
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should set the correct headers" do
      do_get
      { 'Content-Transfer-Encoding' => 'binary', 'Content-Disposition' => 'inline; filename="preview.png"',
        'Cache-Control' => 'private' }.each do |key, value|
         response.headers[key].should == value 
      end
    end
  end
  
  describe "handling GET /admin/themes/1/activate" do
    define_models :themes_controller
    
    before(:each) do
      login_as(:admin)
    end
    
    def do_put
      put :activate, :id => 'dark'
    end
    
    it "should render not found if there is no theme" do
      put :activate, :id => 'nope'
      response.should be_missing
    end
    
    it "should redirect to the themes list" do
      do_put
      response.should redirect_to(admin_themes_path)
    end
    
    it "should change the site" do
      sites(:default).update_attribute(:theme_path, 'light')
      do_put
      sites(:default).reload.theme_path.should == 'dark'
    end
    
    it "should expire all of the cache items" do
      lambda { do_put }.should expire(CacheItem.find(:all))
    end
  end
  
  describe "handling DELETE /admin/themes/1" do
    define_models :themes_controller
    
    before(:each) do
      @theme = mock_model(Theme, :name => 'test', :active? => false, :destroy => true)
      Theme.stub!(:find_all_for).and_return([@theme])
      login_as(:admin)
    end
    
    def do_delete
      delete :destroy, :id => 'test'
    end
    
    it "should destroy the theme" do
      @theme.should_receive(:destroy)
      do_delete
    end
    
    it "should not destroy the active theme" do
      @theme.stub!(:active?).and_return(true)
      @theme.should_not_receive(:destroy)
      do_delete
    end
    
    it "should redirect to the themes list" do
      do_delete
      response.should redirect_to(admin_themes_path)
    end
  end
end
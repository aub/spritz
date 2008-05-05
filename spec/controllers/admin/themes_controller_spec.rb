require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ThemesController do
  define_models :themes_controller

  before(:all) do
    cleanup_theme_directory
    Theme.create_defaults_for(sites(:default))
  end
  
  before(:each) do
    activate_site(:default)
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
      assigns[:themes].should == sites(:default).themes
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
  end
end
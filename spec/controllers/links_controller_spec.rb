require File.dirname(__FILE__) + '/../spec_helper'

describe LinksController do
  define_models :links_controller
  
  before(:each) do
    activate_site(:default)
    stub_site_themes
  end

  describe "handling GET /links" do
    define_models :links_controller
    
    it "should be successful" do
      get :show
      response.should be_success
    end
    
    it "should render the links template" do
      get :show
      response.should render_template('links')
    end
    
    it "should create a cache object" do
      lambda { get :show }.should change(CacheItem, :count).by(1)
    end
  end
    
  describe "site, login, and admin requirements" do
    define_models :links_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :show }])
    end
        
    it "should not require login" do
      test_login_requirement(false, false, [
        lambda { get :show }])
    end
  end
end

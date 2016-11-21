require File.dirname(__FILE__) + '/../spec_helper'

describe NewsController do
  define_models :news_controller
  
  before(:each) do
    activate_site(:default)
    stub_site_themes
  end

  describe "handling GET /news" do
    define_models :news_controller
    
    it "should be successful" do
      get :show
      response.should be_success
    end
    
    it "should render the news template" do
      get :show
      response.should render_template('news')
    end
    
    it "should create a cache object" do
      lambda { get :show }.should change(CacheItem, :count).by(1)
    end
  end
    
  describe "site, login, and admin requirements" do
    define_models :news_controller
    
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

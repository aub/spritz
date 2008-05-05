require File.dirname(__FILE__) + '/../spec_helper'

describe NewsItemsController do
  define_models :news_items_controller
  
  before(:each) do
    activate_site(:default)
    stub_site_themes
  end

  describe "handling GET /" do
    define_models :news_items_controller
    
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should render the news_items template" do
      get :index
      response.should render_template('news_items')
    end
  end
    
  describe "site, login, and admin requirements" do
    define_models :news_items_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index }])
    end
        
    it "should not require login" do
      test_login_requirement(false, false, [
        lambda { get :index }])
    end
  end
end

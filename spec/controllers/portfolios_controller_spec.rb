require File.dirname(__FILE__) + '/../spec_helper'

describe PortfoliosController do
  define_models :portfolios_controller do
    model Portfolio do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
    end
  end
  
  before(:each) do
    activate_site(:default)
  end

  describe "handling GET /portfolios/1" do
    define_models :portfolios_controller
    
    def do_get
      get :show, :id => portfolios(:one)
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render the portfolios template" do
      do_get
      response.should render_template('portfolio')
    end
    
    it "should assign the first portfolio in the site" do
      do_get
      assigns[:portfolio].should == portfolios(:one)
    end
  end
    
  describe "site, login, and admin requirements" do
    define_models :links_controller
    
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

require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::DashboardController do
  
  define_models :dashboard_controller
  
  before(:each) do
    @active_site = mock_model(Site, :domain => 'www.booya.com', :page_cache_path => 'also/junk')
    activate_site(@active_site)
    login_as(:admin)
  end

  describe "handling GET /admin/dashboard" do
    define_models :dashboard_controller
  
    def do_get
      get :show
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render show template" do
      do_get
      response.should render_template('show')
    end  
  end
  
  describe "admin, login, and site requirements" do
    define_models :dashboard_controller
    
    it "should require a site" do
      test_site_requirement(true, lambda { get :show })
    end
        
    it "should require login" do
      test_login_requirement(true, false, lambda { get :show })
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe ResumeController do
  define_models :resume_controller
  
  before(:each) do
    activate_site(:default)
    stub_site_themes
  end

  describe "handling GET /" do
    define_models :resume_controller
    
    it "should be successful" do
      get :show
      response.should be_success
    end
    
    it "should render the resume template" do
      get :show
      response.should render_template('resume')
    end
  end
    
  describe "site, login, and admin requirements" do
    define_models :resume_controller
    
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

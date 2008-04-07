require File.dirname(__FILE__) + '/../spec_helper'

# Doing this so that we can make requests to it.
describe Admin::SessionsController do
  define_models :application_controller
  
  describe "admin? helper" do
    define_models :application_controller
    
    it "should return true if the logged in user is an admin" do
      login_as(:admin)
      controller.should be_admin
    end
    
    it "should return false if noone is logged in" do
      controller.stub!(:logged_in?).and_return(false)
      controller.should_not be_admin
    end
    
    it "should return false if the logged in user isn't an admin" do
      login_as(:nonadmin)
      controller.should_not be_admin
    end
  end
  
  describe "site management" do
    it "should redirect to the new site path if there is no matching site" do
      Site.should_receive(:for).with(request.host, request.subdomains).and_return(nil)
      get :new
      response.should redirect_to(new_admin_site_path)
    end

    it "should allow the request to continue for a good site" do
      Site.should_receive(:for).with(request.host, request.subdomains).and_return(mock_model(Site))
      get :new
      response.should be_success
    end    
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

# Doing this so that we can make requests to it.
describe Admin::SessionController do
  define_models :application_controller
  
  describe "admin? helper" do
    define_models :application_controller
    
    before(:each) do
      activate_site(sites(:default))
      get :new
    end
    
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
      Site.should_receive(:for).with(request.host).and_return(nil)
      get :new
      response.should redirect_to(new_admin_site_path)
    end
  
    it "should allow the request to continue for a good site" do
      Site.should_receive(:for).with(request.host).at_least(1).times.and_return(mock_model(Site, :action_cache_root => 'junk', :page_cache_path => 'also/junk'))
      get :new
      response.should be_success
    end
    
    it "should have a readable attribute for the site" do
      site = mock_model(Site, :action_cache_root => 'junk', :page_cache_path => 'also/junk')
      Site.stub!(:for).and_return(site)
      get :new
      controller.site.should == site
    end
  end
  
  describe "caching support" do
    define_models :application_controller
    
    before(:each) do
      activate_site :default
    end
    
    it "should have a method or holding the referenced objects for the current action" do
      controller.send(:cached_references).should be_a_kind_of(Array)
    end
    
    it "should clear the cached references before each action" do
      controller.send(:cached_references) << 'a'
      controller.send(:cached_references).size.should == 1
      get :new
      controller.send(:cached_references).size.should == 0
    end
    
    it "should set up the root action cache directory" do
      get :new
      controller.action_cache_root.should == sites(:default).action_cache_root
    end
  end
end

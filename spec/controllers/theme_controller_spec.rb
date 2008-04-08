require File.dirname(__FILE__) + '/../spec_helper'

describe ThemeController do
  define_models :theme_controller

  before(:each) do
    activate_site(:default)
  end
  
  describe "site, login, and admin requirements" do
    define_models :theme_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :stylesheets, :filename => 'f', :ext => 'css' },
        lambda { get :images, :filename => 'f', :ext => 'png' },
        lambda { get :javascripts, :filename => 'f', :ext => 'js' }])
    end
        
    it "should not require login" do
      test_login_requirement(false, false, [
        lambda { get :stylesheets, :filename => 'f', :ext => 'css' },
        lambda { get :images, :filename => 'f', :ext => 'png' },
        lambda { get :javascripts, :filename => 'f', :ext => 'js' }])
    end
  end
  
  describe "rendering files" do    
    define_models :theme_controller
    
    it "should render not found if the path contains .. (for safety)" do
      get :stylesheets, :filename => 'a/b/../c', :ext => 'css'
      response.should be_missing
    end
    
    it "should return not found if the file doesn't exist" do
      p = mock_model(Pathname)
      p.stub!(:file?).and_return(false)
      Pathname.stub!(:new).and_return(p)
      get :images, :filename => 'f', :ext => 'png'
      response.should be_missing
    end
  end
end

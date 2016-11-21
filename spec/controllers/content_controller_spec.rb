require File.dirname(__FILE__) + '/../spec_helper'

# have to use the home controller in order to get some routes
describe HomeController do
  define_models :content_controller
  
  before(:each) do
    activate_site(:default)
  end
  
  it "should add the theme's template path to the view search path" do
    sites(:default).stub!(:theme).and_return(Theme.new('hack', sites(:default)))
    get :show
    (controller.view_paths - ::ActionController::Base.view_paths).pop.should == 
      File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}", 'hack/templates')
  end
  
  it "should add the theme's path to the view search path" do
    sites(:default).stub!(:theme).and_return(Theme.new('hack', sites(:default)))
    get :show
    (controller.view_paths - ::ActionController::Base.view_paths)[0].should == 
      File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}", 'hack')
  end
end

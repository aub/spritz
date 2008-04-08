require File.dirname(__FILE__) + '/../spec_helper'

# have to use the home controller in order to get some routes
describe HomeController do
  define_models :content_controller
  
  before(:each) do
    activate_site(:default)
  end
  
  it "should add the theme's path to the view search path" do
    sites(:default).theme = 'testy'
    get :show
    controller.view_paths.should == 
      ::ActionController::Base.view_paths.dup.unshift("#{RAILS_ROOT}/tmp/themes/testy/views")
  end  
end

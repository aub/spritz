require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController do
  define_models :home_controller
  
  before(:each) do
    activate_site(:default)
  end

  describe "handling GET /" do
    define_models :home_controller
    
    it "should be successful" do
      get :show
      response.should be_success
    end
    
    it "should render the show template" do
      get :show
      response.should render_template('show')
    end
  end
end

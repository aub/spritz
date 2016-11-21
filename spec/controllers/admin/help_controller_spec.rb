require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HelpController do
  define_models :help_controller
  
  before(:each) do
    activate_site :default
  end
  
  describe "handling GET /admin/help/show" do
    define_models :help_controller
    
    before(:each) do
      login_as :admin
    end
    
    def do_get(page)
      get :show, :page => page
    end
        
    it "should be successful" do
      do_get 'textile'
      response.should be_success
    end
    
    it "should render the template for the given page" do
      do_get 'textile'
      response.should render_template('textile')
    end
  end
end

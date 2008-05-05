require File.dirname(__FILE__) + '/../spec_helper'

describe ContactController do
  define_models :contact_controller
  
  before(:each) do
    activate_site(:default)
    stub_site_themes
  end

  describe "handling GET /contact/new" do
    define_models :contact_controller
    
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should render the contact template" do
      get :new
      response.should render_template('contact')
    end    
  end
  
  describe "handling POST /contact" do
    define_models :contact_controller

    describe "with successful save" do
      define_models :contact_controller
    
      def do_post
        post :create, :contact => { :name => 'John Doe', :email => 'lame@name.com' }
      end

      it "should create a new contact" do
        lambda { do_post }.should change(Contact, :count).by(1)
      end
  
      it "should re-render the new contact page" do
        do_post
        response.should render_template('contact')
      end
      
      it "should provide a message for the template" do
        do_post
        assigns[:message].should_not be_empty
      end

      describe "with failed save" do
        define_models :contact_controller

        def do_post
          post :create, :contact => {}
        end

        it "should re-render 'new'" do
          do_post
          response.should render_template('contact')
        end
      end
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :contact_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :new }])
    end
        
    it "should not require login" do
      test_login_requirement(false, false, [
        lambda { get :new }])
    end
  end
end

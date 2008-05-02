require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SettingsController do
  define_models :settings_controller
  
  before(:each) do
    login_as :admin
    activate_site :default
  end
  
  describe "handling GET admin/settings/edit" do
    define_models :settings_controller
    
    def do_get
      get :edit
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render the edit template" do
      do_get
      response.should render_template('edit')
    end
    
    it "should assign the site" do
      do_get
      assigns[:site].should == sites(:default)
    end
  end
  
  describe "handling PUT /admin/settings" do
    define_models :settings_controller
    
    def do_put
      put :update, :site => { :title => 'a-title' }
    end
    
    it "should redirect to the settings page" do
      do_put
      response.should redirect_to(edit_admin_settings_path)
    end
    
    it "should set the flash" do
      do_put
      flash[:notice].should_not be_nil
    end
    
    it "should update the site attributes" do
      do_put
      sites(:default).reload.title.should == 'a-title'
    end
    
    describe "with failed save" do
      define_models :settings_controller
      
      def do_put
        put :update, :site => { :title => nil, :theme => nil }
      end
      
      it "should render the edit action" do
        do_put
        response.should render_template(:edit)
      end
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :settings_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :show },
        lambda { get :edit },
        lambda { put :update, :site => {} }])
    end
    
    it "should require member login" do
      test_login_requirement(true, false, [
        lambda { get :show },
        lambda { get :edit },
        lambda { put :update, :site => {} }])
    end
  end
end

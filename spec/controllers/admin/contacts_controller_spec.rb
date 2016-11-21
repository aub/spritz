require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ContactsController do
  define_models :contacts_controller do
    model Contact do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
      stub :tre, :site => all_stubs(:other_site)
    end
  end
  
  before(:each) do
    activate_site(:default)
  end
  
  describe "handling GET /admin/contacts" do
    define_models :contacts_controller

    before(:each) do
      login_as(:admin)
    end

    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
    
    it "should assign the found contacts for the view" do
      do_get
      assigns[:contacts].sort_by(&:id).should == [contacts(:one), contacts(:two)].sort_by(&:id)
    end
  end

  describe "handling DELETE /admin/contacts/1" do
    define_models :contacts_controller
    
    before(:each) do
      login_as(:admin)
    end

    def do_delete
      delete :destroy, :id => contacts(:one).id
    end
  
    it "should call destroy on the found contact" do
      lambda { do_delete }.should change(Contact, :count).by(-1)
    end
  
    it "should redirect to the admin_contacts list" do
      do_delete
      response.should redirect_to(admin_contacts_path)
    end
    
    it "should not delete contacts that are in another site" do
      delete :destroy, :id => contacts(:tre).id
      response.should be_missing
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :contacts_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { get :show, :id => contacts(:one).id },
        lambda { delete :destroy, :id => contacts(:one).id }])
    end
    
    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :index },
        lambda { get :show, :id => contacts(:one).id },
        lambda { delete :destroy, :id => contacts(:one).id }])
    end
  end
end
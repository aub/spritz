require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ResourcesController do
  define_models :resources_controller

  before(:all) do
    cleanup_theme_directory
    Theme.create_defaults_for(sites(:default))
  end
  
  before(:each) do
    activate_site(:default)
  end
  
  after(:all) do
    cleanup_theme_directory
  end

  describe "handling GET /admin/resources" do
    define_models :resources_controller
    
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
  
    it "should assign the site's current theme for the view" do
      do_get
      assigns[:theme].should eql(sites(:default).theme)
    end
  end
  
  describe "handling GET /admin/resources/1/edit" do
    define_models :resources_controller
    
    before(:each) do
      login_as(:admin)
    end
    
    def do_get
      get :edit, :id => sites(:default).theme.resources.first.name
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should assign the site's current theme for the view" do
      do_get
      assigns[:theme].should eql(sites(:default).theme)
    end
    
    it "should assign the resource for the view" do
      do_get
      assigns[:resource].should == sites(:default).theme.resources.first
    end
  end

  describe "handling PUT /admin/resources/1" do
    define_models :resources_controller
    
    before(:each) do
      login_as(:admin)
      @resource = sites(:default).theme.resources.first
    end
    
    def do_put
      put :update, :id => @resource.name, :data => 'tiger lilly'
    end
  
    it "should redirect back to the edit page" do
      do_put
      response.should redirect_to(edit_admin_theme_resource_path(sites(:default).theme, @resource))
    end
      
    it "should update the resource" do
      @resource.write('i know you tried')
      do_put
      @resource.read.should == 'tiger lilly'
    end
  end  
end
require File.dirname(__FILE__) + '/../../spec_helper'

class LinkSection < Section
  cattr_accessor :section_name, :section_class
  @@section_name = 'Links'
end

describe Admin::SectionsController do
  define_models :sections_controller
  
  before(:each) do
    activate_site :default
    login_as :admin    
  end
  
  describe "handling GET /admin/sections" do
    define_models :sections_controller do
      model Section do
        stub :one, :site => all_stubs(:site), :position => 0
        stub :two, :site => all_stubs(:site), :position => 1
      end
    end
    
    before(:each) do
      Spritz::Plugin.stub!(:section_types).and_return(['a', 'b', 'c'])
    end
    
    def do_get
      get :index
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render the index template" do
      do_get
      response.should render_template('index')
    end
    
    it "should assign the list of section types" do
      do_get
      assigns[:available_section_types].should == ['a', 'b', 'c']
    end
    
    it "should assign the list of sections in the current sit" do
      do_get
      assigns[:sections].should == [sections(:one), sections(:two)].sort_by(&:position)
    end
  end
  
  describe "handling POST /admin/sections" do
    define_models :sections_controller
    
    before(:each) do
      Spritz::Plugin.stub!(:section_types).and_return([LinkSection])
    end
    
    def do_post
      post :create, :name => LinkSection.section_name
    end
    
    it "should create a new instance of the section class" do
      LinkSection.should_receive(:create).and_return(LinkSection.new)
      do_post
    end
    
    it "should add the new instance to the active site" do
      lambda { do_post }.should change(sites(:default).sections, :count).by(1)
    end
    
    it "should redirect to the index action" do
      do_post
      response.should redirect_to(admin_sections_path)
    end
  end
  
  describe "admin, login, and site requirements" do
    define_models :sections_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { post :create }])
    end
        
    it "should require login" do
      test_login_requirement(true, false, [
        lambda { get :index },
        lambda { post :create }])
    end
  end
end

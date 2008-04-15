require File.dirname(__FILE__) + '/../spec_helper'

describe DispatchController do
  define_models :dispatch_controller

  before(:each) do
    activate_site sites(:default)
    
    @section1 = mock_model(Hash, :handle_request => nil, :name => 'Section1')
    @section2 = mock_model(Hash, :handle_request => nil, :name => 'Section2')
    sites(:default).stub!(:sections).and_return([@section1, @section2])
    
    @valid_data = [:junk, {:a => 'aa', :b => 'bb', :c => 'cc' }]
  end
  
  describe "handling GET dispatch" do
    define_models :dispatch_controller
        
    def do_get(section_name='Section2')
      get :dispatch, :path => [section_name, 'one', 'two']
    end
        
    it "should call handle request on the section type whose name matches" do
      @section1.should_receive(:handle_request).and_return(nil)
      do_get('Section1')
    end
    
    it "should not call handle request on sections whose names do not match" do
      @section2.should_not_receive(:handle_request)
      do_get('Section1')
    end
    
    it "should assign instance variables from the data in the response" do
      @section2.stub!(:handle_request).and_return(@valid_data)
      do_get
      assigns[:a].should == 'aa'
      assigns[:b].should == 'bb'
      assigns[:c].should == 'cc'
    end
    
    it "should render the template from the response" do
      @section2.stub!(:handle_request).and_return(@valid_data)
      do_get
      response.should render_template(@valid_data[0])
    end
    
    it "should be successful when data is returned" do
      @section2.stub!(:handle_request).and_return(@valid_data)
      do_get
      response.should be_success      
    end
    
    it "should render 404 if there is no match" do
      do_get
      response.should be_missing
    end
    
    it "should render 404 for bad paths" do
      @section2.stub!(:handle_request).and_return(@valid_data)
      get :dispatch, :path => [@section2.name, '', 'two']
      response.should be_missing
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :dispatch_controller
    
    it "should require a site" do
      test_site_requirement(true, lambda { get :dispatch, :path => ['a'] })
    end
        
    it "should not require login" do
      test_login_requirement(false, false, lambda { get :dispatch, :path => ['a'] })
    end
  end
  
end

require File.dirname(__FILE__) + '/../spec_helper'

describe DispatchController do
  define_models :dispatch_controller

  before(:each) do
    activate_site sites(:default)
    
    @section1 = mock_model(Hash, :handle_request => nil)
    @section2 = mock_model(Hash, :handle_request => nil)
    sites(:default).stub!(:sections).and_return([@section1, @section2])
    
    @valid_data = [:junk, {:a => 'aa', :b => 'bb', :c => 'cc' }]
  end
  
  describe "handling GET dispatch" do
    define_models :dispatch_controller
        
    it "should call handle request on each of the section types" do
      @section1.should_receive(:handle_request).and_return(nil)
      @section2.should_receive(:handle_request).and_return(nil)
      get :dispatch
    end
    
    it "should stop processing if one of the sections returns non-nil" do
      @section1.stub!(:handle_request).and_return(@valid_data)
      @section2.should_not_receive(:handle_request)
      get :dispatch
    end
    
    it "should assign instance variables from the data in the response" do
      @section2.stub!(:handle_request).and_return(@valid_data)
      get :dispatch
      assigns[:a].should == 'aa'
      assigns[:b].should == 'bb'
      assigns[:c].should == 'cc'
    end
    
    it "should render the template from the response" do
      @section2.stub!(:handle_request).and_return(@valid_data)
      get :dispatch
      response.should render_template(@valid_data[0])
    end
    
    it "should render 404 if there is no match" do
      get :dispatch
      response.should be_missing
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :dispatch_controller
    
    it "should require a site" do
      test_site_requirement(true, lambda { get :dispatch })
    end
        
    it "should not require login" do
      test_login_requirement(false, false, lambda { get :dispatch })
    end
  end
  
end

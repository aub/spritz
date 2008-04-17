require File.dirname(__FILE__) + '/../spec_helper'

describe DispatchController do
  define_models :dispatch_controller
      
  before(:each) do
    activate_site sites(:default)
    
    @section1 = mock_model(Section, :title => 'Section1')
    @section1.stub!(:handle_request).and_return([:junk, {:a => 'aa' }])
    sites(:default).stub!(:sections).and_return([@section1])
    
    FileUtils.rm_rf(ActionController::Base.fragment_cache_store.cache_path)
  end
  
  def do_get
    @path = [@section1.title, 'link', '1']
    get :dispatch, :path => @path
    response.should be_success
  end
  
  it "should create a cache object" do
    lambda { do_get }.should change(CacheItem, :count).by(1)
  end
  
  it "should create a cache object that makes sense" do
    do_get
    CacheItem.find_by_site_id_and_path(sites(:default).id, File.join(sites(:default).subdomain, @path)).should_not be_nil
  end
  
  it "should set references properly on the cache" do
    controller.stub!(:cached_references).and_return([sites(:default), users(:admin)])
    do_get
    cache = CacheItem.find_by_site_id_and_path(sites(:default).id, File.join(sites(:default).subdomain, @path))
    cache.references.should == "[#{sites(:default).id}:#{sites(:default).class.name}][#{users(:admin).id}:#{users(:admin).class.name}]"
  end
  
  it "should create the cache file" do
    lambda { do_get }.should cache_action
  end  
end
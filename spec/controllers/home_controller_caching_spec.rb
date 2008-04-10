require File.dirname(__FILE__) + '/../spec_helper_caching'

describe HomeController do
  include CachingExampleHelper

  define_models :home_controller
  
  before(:each) do
    activate_site(:default)
  end
  
  it "should create a cache object" do
    lambda { action { get :show } }.should change(CacheItem, :count).by(1)
  end
  
  it "should create a cache object that makes sense" do
    action { get :show }
    CacheItem.find_by_site_id_and_path(sites(:default).id, File.join(sites(:default).subdomain, 'index')).should_not be_nil
  end

  it "should set references properly on the cache" do
    controller.stub!(:cached_references).and_return([sites(:default), users(:admin)])
    action { get :show }
    cache = CacheItem.find_by_site_id_and_path(sites(:default).id, File.join(sites(:default).subdomain, 'index'))
    cache.references.should == "[#{sites(:default).id}:#{sites(:default).class.name}][#{users(:admin).id}:#{users(:admin).class.name}]"
  end
  
  it "should cache the show action" do
    action { get :show }.should be_cached
  end  
end
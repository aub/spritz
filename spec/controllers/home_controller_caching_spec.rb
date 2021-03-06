require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController do
  define_models :home_controller
    
  before(:each) do
    activate_site(:default)
    stub_site_themes
    FileUtils.rm_rf(ActionController::Base.cache_store.cache_path)
  end
  
  it "should create a cache object" do
    lambda { get :show }.should change(CacheItem, :count).by(1)
  end

  describe "with multi-site enabled" do
    define_models :home_controller
    
    it "should create a cache object that makes sense" do
      get :show
      CacheItem.find_by_site_id_and_path(sites(:default).id, '/').should_not be_nil
    end

    it "should set references properly on the cache" do
      controller.stub!(:cached_references).and_return([sites(:default), users(:admin)])
      get :show
      cache = CacheItem.find_by_site_id_and_path(sites(:default).id, '/')
      cache.references.should == "[#{sites(:default).id}:#{sites(:default).class.name}][#{users(:admin).id}:#{users(:admin).class.name}]"
    end
  end
end

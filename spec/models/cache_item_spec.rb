require File.dirname(__FILE__) + '/../spec_helper'

describe CacheItem do
  define_models :cache_item do
    model CacheItem do
      stub :foo, :site => all_stubs(:site), :type => 'CacheItem', :path => 'a/b/c', :references => 'abcde'
    end
  end
  
  describe "standard settings" do
    define_models :cache_item
    
    it "should description" do
      cache_items(:foo).site.should == sites(:default)
    end
  end
  
  describe "validations" do
    before(:each) do
      @cache = CacheItem.new
      @cache.should_not be_valid
    end
    
    it "should require a site" do
      @cache.should have(1).errors_on(:site_id)
    end
    
    it "should require a path" do
      @cache.should have(1).errors_on(:path)
    end
  end
  
  describe "using create for" do
    define_models :cache_item
    
    before(:each) do
      @cache = CacheItem.for(sites(:default), 'fake/path', [sites(:default), users(:admin)])
    end
    
    it "should build a cache object" do
      @cache.should be_a_kind_of(CacheItem)
    end
    
    it "should have the appropriate site" do
      @cache.site.should == sites(:default)
    end
    
    it "should have the appropriate path" do
      @cache.path.should == 'fake/path'
    end
    
    describe "reference creation" do
      define_models :cache_item
      
      it "should have the appropriate references" do
        @cache.references.should == "[#{sites(:default).id}:#{sites(:default).class.name}][#{users(:admin).id}:#{users(:admin).class.name}]"
      end
      
      it "should remove duplicate references" do
        @cache = CacheItem.for(sites(:default), 'fake/path', [sites(:default), sites(:default)])
        @cache.references.should == "[#{sites(:default).id}:#{sites(:default).class.name}]"
      end
      
      it "should remove nil references" do
        @cache = CacheItem.for(sites(:default), 'fake/path', [nil, sites(:default), nil, sites(:default), nil])
        @cache.references.should == "[#{sites(:default).id}:#{sites(:default).class.name}]"        
      end
    end
    
    describe "model creation" do
      define_models :cache_item
      
      it "should use an existing object for the given site and path, if it exists" do
        @cache = CacheItem.for(cache_items(:foo).site, cache_items(:foo).path, [])
        @cache.id.should == cache_items(:foo).id
      end
      
      it "should save the changes to the model" do
        @cache = CacheItem.for(cache_items(:foo).site, cache_items(:foo).path, [])
        @cache.reload.references.should == ''       
      end
    end
  end
  
  describe "find methods" do
    define_models :cache_item
        
    before(:each) do
      # Create a few cache items.
      [['a/b/c/d', [sites(:default)]], ['a/b/c/d/e', [users(:admin)]], ['asd', [users(:admin), sites(:default)]]].each do |item|
        CacheItem.for(sites(:default), item[0], item[1])
      end
    end
    
    it "should support finding for a list of objects" do
      CacheItem.find_for_records(*[sites(:default), users(:admin)]).size.should == 3
    end
    
    it "should support finding for a single record" do
      CacheItem.find_for_record(sites(:default)).size.should == 2
    end
  end
  
  describe "expiration" do
    define_models :cache_item
    
    before(:each) do
      @controller = mock_model(ApplicationController, :expire_action => true)
    end
    
    it "should call expire_action on the given controller when expiring" do
      @controller.should_receive(:expire_action).with(cache_items(:foo).path)
      cache_items(:foo).expire!(@controller)
    end
    
    it "should destroy itself after expiring the cache" do
      cache_items(:foo).should_receive(:destroy)
      cache_items(:foo).expire!(@controller)
    end
    
    it "should remove the cache item" do
      lambda { cache_items(:foo).expire!(@controller) }.should change(CacheItem, :count).by(-1)
    end
  end
end

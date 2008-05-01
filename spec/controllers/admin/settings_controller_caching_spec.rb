require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SettingsController do
  define_models :settings_controller
  
  before(:each) do
    activate_site :default
    login_as :admin
    # Create a few cache items.
    @a = CacheItem.for(sites(:default), 'a', [sites(:default)])
    @b = CacheItem.for(sites(:default), 'b', [users(:admin)])
    @c = CacheItem.for(sites(:default), 'c', [sites(:default), users(:admin)])
    @d = CacheItem.for(sites(:other), 'd', [sites(:other), users(:admin)])
  end
  
  describe "calling update" do
    define_models :settings_controller
    
    it "should expire pages relating to the site" do
      lambda { put :update, :id => sites(:default).id, :site => { :title => 'ack' } }.should expire([@a, @c])
    end
    
    it "should not expire other pages" do
      lambda { put :update, :id => sites(:default).id, :site => { :title => 'ack' } }.should_not expire([@b, @d])
    end
  end  
end
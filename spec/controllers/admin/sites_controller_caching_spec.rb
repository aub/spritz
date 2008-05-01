require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SitesController do
  define_models :sites_controller
  
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
    define_models :sites_controller
    
    it "should expire pages relating to the site" do
      lambda { put :update, :id => sites(:default).id, :site => {} }.should expire([@a, @c])
    end
    
    it "should not expire other pages" do
      lambda { put :update, :id => sites(:default).id, :site => {} }.should_not expire([@b, @d])
    end
  end
  
  describe "calling create" do
    define_models :sites_controller
    
    it "should not expire any pages" do
      lambda { post :create, :site => { :subdomain => 'test' }
       }.should_not expire([@a, @b, @c, @d])
    end
  end
  
  describe "calling destroy" do
    define_models :sites_controller

    # There's something misleading here. The first example will actually "expire" item @b.
    # This is because my expire test just checks to see if the item exists in the database
    # any more. In this case, the site will be destroyed, and because the cache_items are
    # dependent => destroy it will be deleted. Not ideal, but should just be confusing for
    # specs relating to the site (i.e. only this one).
    
    it "should expire pages relating to the site" do
      lambda { delete :destroy, :id => sites(:default).id }.should expire([@a, @b, @c])
    end
    
    it "should not expire other pages" do
      lambda { delete :destroy, :id => sites(:default).id }.should_not expire([@d])
    end
  end
end
require File.dirname(__FILE__) + '/../../spec_helper'

class LinkSection < Section
  cattr_accessor :name, :section_class
  @@section_name = 'Links'
end

describe Admin::SectionsController do
  define_models :sections_controller do
    model Site do
      stub :other, :subdomain => 'hacky'
    end
  end
  
  before(:each) do
    activate_site :default
    login_as :admin
    Spritz::Plugin.stub!(:section_types).and_return([LinkSection])
    # Create a few cache items.
    @a = CacheItem.for(sites(:default), 'a', [sites(:default)])
    @b = CacheItem.for(sites(:default), 'b', [users(:admin)])
    @c = CacheItem.for(sites(:default), 'c', [sites(:default), users(:admin)])
    @d = CacheItem.for(sites(:other), 'd', [sites(:other), users(:admin)])
  end
  
  describe "calling create" do
    define_models :sections_controller

    def do_put
      put :create, :name => LinkSection.section_name
    end
    
    it "should expire pages relating to the site" do
      lambda { do_put }.should expire([@a, @c])
    end
    
    it "should not expire other pages" do
      lambda { do_put }.should_not expire([@b, @d])
    end
  end  
end
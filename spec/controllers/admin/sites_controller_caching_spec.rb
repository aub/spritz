require File.dirname(__FILE__) + '/../../spec_helper_caching'

describe SitesController do
  include CachingExampleHelper
  
  define_models :sites_controller
  
  describe "when the site changes" do
    define_models :sites_controller
    
    it "should expire associated pages" do
      expiring { put :update, :id => sites(:default).id }.should_not be_cached
    end
  end
end
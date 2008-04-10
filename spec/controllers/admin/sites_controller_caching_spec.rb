require File.dirname(__FILE__) + '/../../spec_helper_caching'

describe Admin::SitesController do
  include CachingExampleHelper
  
  define_models :sites_controller
  
  describe "when the site changes" do
    define_models :sites_controller    
  end
end
require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::SessionController do
  
  describe "with multi-site enabled" do
    define_models :caching_methods
    
    before(:each) do
      activate_site :default
      @hack = Admin::SessionController.new
      Site.multi_sites_enabled = true
    end

    after(:all) do
      Site.multi_sites_enabled = false
    end
    
    it "should call caches_action for the with_references call" do
      @hack.class.should_receive(:caches_page)
      @hack.class.send(:caches_with_references, :action1, :action2)
    end
  end
  
  describe "with multi-site disabled" do
    before(:each) do
      @hack = Admin::SessionController.new
      Site.multi_sites_enabled = false
    end
    
    it "should call caches_page for the with_references call" do
      @hack.class.should_receive(:caches_page).with(:action1, :action2)
      @hack.class.send(:caches_with_references, :action1, :action2)
    end
  end
end

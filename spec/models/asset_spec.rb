require File.dirname(__FILE__) + '/../spec_helper'

describe Asset do
  define_models :asset do
    model Asset do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  describe "validations" do
    
    before(:each) do
      @asset = Asset.new
      @asset.should_not be_valid
    end
  
    it "should require a site" do
      @asset.should have(1).error_on(:site_id)
    end
    
    it "should validate as an attachment" do
      @asset.should have(2).error_on(:size)
      @asset.should have(1).error_on(:content_type)
      @asset.should have(1).error_on(:filename)
    end
  end
  
  describe "relationship to sites" do
    define_models :asset
    
    it "should belong to a site" do
      assets(:one).site.should == sites(:default)
    end
  end
end

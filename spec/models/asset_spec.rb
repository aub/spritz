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
  
  describe "relationship with data" do
    define_models :asset

    before(:each) do
      assets(:one).uploaded_data = asset_file
      assets(:one).save.should be_true
    end
    
    it "should be creatable from data" do
      assets(:one).save.should be_true
    end
    
    it "should create thumbnails" do
      assets(:one).thumbnails.size.should == 3
    end
  end
  
  protected
  
  def asset_file(options={})
    fixture_file_upload(File.join(%w(assets icon.png)), options[:content_type] || 'image/png')
  end
end

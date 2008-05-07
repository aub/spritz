require File.dirname(__FILE__) + '/../spec_helper'

num_thumbnails = 4

describe Asset do
  define_models :asset do
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'fake1', :content_type => 'a_type', :size => 12
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
    end
    model AssignedAsset do
      stub :one, :portfolio => all_stubs(:one_portfolio), :asset => all_stubs(:one_asset)
      stub :two, :portfolio => all_stubs(:two_portfolio), :asset => all_stubs(:one_asset)
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
      assets(:one).thumbnails.size.should == num_thumbnails
    end
  end

  describe "relationship to assigned assets" do
    define_models :asset
    
    it "should have a collection of assigned assets" do
      assets(:one).assigned_assets.sort_by(&:id).should == [assigned_assets(:one), assigned_assets(:two)].sort_by(&:id)
    end
    
    it "should destroy the assigned assets when it is destroyed" do
      lambda { assets(:one).destroy }.should change(AssignedAsset, :count).by(-2)
    end
  end
  
  describe "field management" do
    define_models :asset
    
    before(:each) do
      @field_names = [ :title, :medium, :dimensions, :date, :price, :description ]
    end
    
    it "should have a list of field names" do
      Asset.field_names.should == @field_names
    end
    
    it "should create accessor methods for each of the fields" do
      a = Asset.new
      @field_names.each { |fn| a.send("#{fn}=", 'happy') }
      @field_names.each { |fn| a.send("#{fn}").should == 'happy' }
    end
    
    it "should set fields with update_attributes" do
      assets(:one).update_attributes({ :title => 'a_title', :medium => 'a_medium' })
      assets(:one).reload.title.should == 'a_title'
    end
  end
  
  protected
  
  def asset_file(options={})
    fixture_file_upload(File.join(%w(assets icon.png)), options[:content_type] || 'image/png')
  end
end

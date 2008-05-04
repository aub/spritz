require File.dirname(__FILE__) + '/../spec_helper'

describe AssignedAssetDrop do
  define_models :assigned_asset_drop do
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'fake1'
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2
    end
    model AssignedAsset do
      stub :one, :asset => all_stubs(:one_asset), :portfolio => all_stubs(:one_portfolio)
    end
  end
    
  before(:each) do
    @drop = AssignedAssetDrop.new(assigned_assets(:one))
  end
  
  it "should provide access to the thumbnail path" do
    @drop.thumbnail_path.should == assets(:one).public_filename(:thumb)
  end
  
  it "should provide access to the display path" do
    @drop.display_path.should == assets(:one).public_filename(:display)
  end

  it "should provide access to the tiny path" do
    @drop.tiny_path.should == assets(:one).public_filename(:tiny)
  end
  
  it "should provide access to a url" do
    @drop.url.should == "/portfolios/#{portfolios(:one).to_param}/items/#{assigned_assets(:one).to_param}"
  end
  
  it "should provide access to the portfolio" do
    @drop.portfolio.should == portfolios(:one).to_liquid
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe AssignedAsset do

  define_models :assigned_asset do
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'fake1'
      stub :two, :site => all_stubs(:site), :filename => 'fake2'
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2
      stub :two, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2
      stub :tre, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2
    end
    model AssignedAsset do
      stub :one, :asset => all_stubs(:one_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio'
    end
  end

  describe "validations" do
    define_models :assigned_asset
    
    it "should require an asset and portfolio" do
      asset = AssignedAsset.new
      asset.should_not be_valid
      asset.should have(1).errors_on(:asset_id)
      asset.should have(1).errors_on(:asset_holder_id)
      asset.should have(1).errors_on(:asset_holder_type)
    end

    it "should require a unique combination of asset and portfolio" do
      asset = AssignedAsset.create(:asset => assets(:one), :asset_holder => portfolios(:one))
      asset.should have(1).errors_on(:asset_id)
    end

    it "should allow an asset to be attached to more than one portfolio" do
      asset1 = AssignedAsset.create(:asset => assets(:one), :asset_holder => portfolios(:two))
      asset2 = AssignedAsset.create(:asset => assets(:one), :asset_holder => portfolios(:tre))
      asset2.should be_valid
    end

    it "should be valid" do
      asset = AssignedAsset.create(:asset => assets(:two), :asset_holder => portfolios(:one))
      asset.should be_valid
    end
  end
  
  it "should belong to an asset" do
    assigned_assets(:one).asset.should == assets(:one)
  end
  
  it "should belong to a portfolio" do
    assigned_assets(:one).asset_holder.should == portfolios(:one)
  end
end

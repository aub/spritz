require File.dirname(__FILE__) + '/../spec_helper'

describe PortfolioItemDrop do
  define_models :portfolio_item_drop do
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'fake1', :fields => { :title => 'way cool', :dimensions => '1x2', :price => '' }
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2
    end
    model AssignedAsset do
      stub :one, :asset => all_stubs(:one_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio'
    end
  end
    
  before(:each) do
    @drop = PortfolioItemDrop.new(assigned_assets(:one))
  end
  
  it "should provide access to the thumbnail path" do
    @drop.thumbnail_path.should == assets(:one).public_filename(:thumb)
  end
  
  it "should provide access to the display path" do
    @drop.display_path.should == assets(:one).public_filename(:display)
  end

  it "should provide access to the medium path" do
    @drop.medium_path.should == assets(:one).public_filename(:medium)
  end

  it "should provide access to the tiny path" do
    @drop.tiny_path.should == assets(:one).public_filename(:tiny)
  end
  
  it "should provide access to a url" do
    @drop.url.should == "/portfolios/#{portfolios(:one).to_param}/items/#{assigned_assets(:one).to_param}"
  end
  
  it "should provide access to the portfolio" do
    @drop.portfolio.should == portfolios(:one)
  end
  
  it "should give the list of fields for the asset" do
    @drop.fields.should == [{"name"=>"title", "value"=>"way cool"}, {"name"=>"dimensions", "value"=>"1x2"}]
  end
  
  it "should not include the fields that are nil" do
    @drop.fields.find { |fld| fld['name'] == 'description' }.should be_nil
  end
  
  it "should not include the fields that are empty" do
    @drop.fields.find { |fld| fld['name'] == 'price' }.should be_nil
  end
end

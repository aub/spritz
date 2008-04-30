require File.dirname(__FILE__) + '/../spec_helper'

describe AssignedAssetDrop do
  
  before(:each) do
    @asset = mock_model(Asset)
    
    @assigned_asset = mock_model(AssignedAsset)
    @assigned_asset.stub!(:asset).and_return(@asset)
    
    @drop = AssignedAssetDrop.new(@assigned_asset)
  end
  
  it "should provide access to the thumbnail path" do
    @asset.should_receive(:public_filename).with(:thumb).and_return('booya')
    @drop.thumbnail_path.should == 'booya'
  end
  
  it "should provide access to the display path" do
    @asset.should_receive(:public_filename).with(:display).and_return('cool')
    @drop.display_path.should == 'cool'
  end
end

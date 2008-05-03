require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AdminHelper do
  it "should have a method for getting the name to use for Assets" do
    assets_name.should == 'Images'
    asset_name.should == 'Image'
  end
end

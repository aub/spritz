require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AdminHelper do
  it "should have a method for getting the name to use for Assets" do
    included_modules = (class << helper; self; end).send :included_modules
    helper.assets_name.should == 'Images'
    helper.asset_name.should == 'Image'
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe Asset do
  before(:each) do
    @asset = Asset.new
  end

  it "should be valid" do
    @asset.should be_valid
  end
end

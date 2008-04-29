require File.dirname(__FILE__) + '/../spec_helper'

describe Link do
  before(:each) do
    @link = Link.new
  end

  it "should be valid" do
    @link.should be_valid
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe SiteDrop do
  before(:each) do
    @site = mock_model(Site, :domain => 'dmn')
    @drop = SiteDrop.new(@site)
  end
    
  it "should provide access to the domain" do
    @drop.before_method('domain').should == @site.domain
  end
end

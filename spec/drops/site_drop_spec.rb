require File.dirname(__FILE__) + '/../spec_helper'

describe SiteDrop do
  before(:each) do
    @site = mock_model(Site, :title => 'ttl')
    @drop = SiteDrop.new(@site)
  end
    
  it "should provide access to the title" do
    @drop.before_method('title').should == @site.title
  end
end

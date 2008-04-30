require File.dirname(__FILE__) + '/../spec_helper'

describe SiteDrop do
  define_models :site_drop do
    model Link do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :parent_id => nil
      stub :two, :site => all_stubs(:site), :parent_id => all_stubs(:one_site).object_id
    end
  end
  
  before(:each) do
    @drop = SiteDrop.new(sites(:default))
  end
    
  it "should provide access to the title" do
    @drop.before_method('title').should == sites(:default).title
  end
  
  it "should provide access to the links" do
    @drop.links.should == sites(:default).links.collect(&:to_liquid)
  end
  
  it "should provide access to the portfolios" do
    @drop.portfolios.should == [portfolios(:one)].collect(&:to_liquid)
  end
end

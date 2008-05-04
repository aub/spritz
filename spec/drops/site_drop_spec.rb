require File.dirname(__FILE__) + '/../spec_helper'

describe SiteDrop do
  define_models :site_drop do
    model Link do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 4
      stub :two, :site => all_stubs(:site), :parent_id => 1, :lft => 2, :rgt => 3
    end
    model NewsItem do
      stub :one, :site => all_stubs(:site)
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
  
  it "should provide access to the news items" do
    @drop.news_items.should == [news_items(:one)].collect(&:to_liquid)
  end
end

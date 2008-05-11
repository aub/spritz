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
      stub :two, :site => all_stubs(:site)
      stub :tre, :site => all_stubs(:site)
    end
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'hacky'
      stub :two, :site => all_stubs(:site), :filename => 'ouch'
    end
    model AssignedAsset do
      stub :one, :asset => all_stubs(:one_asset), :asset_holder => all_stubs(:site), :asset_holder_type => 'Site'
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
    @drop.news_items.should == sites(:default).news_items.collect(&:to_liquid)
  end
  
  it "should provide access to the home text" do
    @drop.before_method('home_text').should == sites(:default).home_text
  end
  
  it "should provide access to the home page news items" do
    sites(:default).update_attribute(:home_news_item_count, 2)
    @drop.home_news_items.should == sites(:default).news_items[0..1].collect(&:to_liquid)
  end
  
  it "should return an empty array if no news items are requested" do
    sites(:default).update_attribute(:home_news_item_count, 0)
    @drop.home_news_items.should == []
  end
  
  it "should return an empty array if the count is nil" do
    sites(:default).update_attribute(:home_news_item_count, nil)
    @drop.home_news_items.should == []
  end
  
  it "should return nil if there are no news items" do
    sites(:default).news_items.each(&:destroy)
    sites(:default).news_items.reload.should == []
    @drop.home_news_items.should == []
  end
  
  it "should provide access to the display-size home image" do
    @drop.home_image_display_path.should == assets(:one).public_filename(:display)
  end

  it "should provide access to the medium-size home image" do
    @drop.home_image_medium_path.should == assets(:one).public_filename(:medium)
  end
  
  it "should return an empty string if the site has no assets" do
    sites(:default).home_image.destroy
    sites(:default).reload.home_image.should == nil
    @drop.home_image_display_path.should == ''
  end

  it "should provide access to the google analytics code" do
    @drop.before_method('google_analytics_code').should == sites(:default).google_analytics_code
  end
end

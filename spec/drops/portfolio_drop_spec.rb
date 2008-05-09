require File.dirname(__FILE__) + '/../spec_helper'

describe PortfolioDrop do
  define_models :portfolio_drop do
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'fake1'
      stub :two, :site => all_stubs(:site), :filename => 'fake2'
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :title => 'a_title', :body => 'a_body', :lft => 1, :rgt => 2
      stub :two, :site => all_stubs(:site), :title => 'a_title', :body => 'a_body', :lft => 3, :rgt => 4
      stub :tre, :site => all_stubs(:site), :title => 'a_title', :body => 'a_body', :lft => 5, :rgt => 6
    end
    model AssignedAsset do
      stub :one, :asset => all_stubs(:one_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio'
      stub :two, :asset => all_stubs(:two_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio'
    end
  end
  
  before(:each) do
    @drop = PortfolioDrop.new(portfolios(:one))
  end
    
  it "should provide access to the title" do
    @drop.before_method('title').should == portfolios(:one).title
  end
  
  it "should provide access to the body" do
    @drop.before_method('body').should == portfolios(:one).body
  end
  
  it "should provide access to the assets" do
    @drop.assets.should == portfolios(:one).assigned_assets.collect { |aa| PortfolioItemDrop.new(aa) }
  end
  
  it "should have a method for getting the url of the portfolio" do
    @drop.url.should == "/portfolios/#{portfolios(:one).to_param}"
  end
  
  it "should have a method for getting the title asset" do
    @drop.title_asset.should == PortfolioItemDrop.new(portfolios(:one).assigned_assets.first)
  end
  
  it "should provide access to the children" do
    portfolios(:two).move_to_child_of(portfolios(:one))
    portfolios(:tre).move_to_child_of(portfolios(:one))
    @drop.children.sort_by(&:object_id).should == [portfolios(:two), portfolios(:tre)].collect(&:to_liquid).sort_by(&:object_id)
  end
  
  it "should provide access to the ancestors" do
    portfolios(:two).move_to_child_of(portfolios(:one))
    portfolios(:tre).move_to_child_of(portfolios(:two))
    PortfolioDrop.new(portfolios(:tre)).ancestors.should == [portfolios(:one), portfolios(:two)].collect(&:to_liquid)
  end
end

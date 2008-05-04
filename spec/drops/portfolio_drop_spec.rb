require File.dirname(__FILE__) + '/../spec_helper'

describe PortfolioDrop do
  define_models :portfolio_drop do
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'fake1'
      stub :two, :site => all_stubs(:site), :filename => 'fake2'
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :title => 'a_title', :body => 'a_body', :lft => 1, :rgt => 2
    end
    model AssignedAsset do
      stub :one, :asset => all_stubs(:one_asset), :portfolio => all_stubs(:one_portfolio)
      stub :two, :asset => all_stubs(:two_asset), :portfolio => all_stubs(:one_portfolio)
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
    @drop.assets.should == portfolios(:one).assigned_assets.collect(&:to_liquid)
  end
  
  it "should have a method for getting the url of the portfolio" do
    @drop.url.should == "/portfolios/#{portfolios(:one).to_param}"
  end
  
  it "should have a method for getting the title asset" do
    @drop.title_asset.should == portfolios(:one).assigned_assets.first.to_liquid
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe Portfolio do
  
  define_models :portfolio do
    model Portfolio do
      stub :one, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 4
    end
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'fake1'
      stub :two, :site => all_stubs(:site), :filename => 'fake2'
    end
    model AssignedAsset do
      stub :one, :asset => all_stubs(:one_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio', :marker => 'display'
      stub :two, :asset => all_stubs(:two_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio', :marker => 'display'
      stub :tre, :asset => all_stubs(:two_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio', :marker => 'something_else'
    end
  end
  
  describe "validations" do
    before(:each) do
      @portfolio = Portfolio.new
    end

    it "should require a title" do
      @portfolio.should_not be_valid
      @portfolio.should have(2).errors_on(:title)
    end
    
    it "should limit the length of the title" do
      @portfolio.title = '012345678901234567890123456789012345678901234567890'
      @portfolio.should have(1).error_on(:title)
    end
    
    it "should be valid" do
      @portfolio.title = '01234567890123456789012345678901234567890123456789'
      @portfolio.should be_valid
    end
  end
  
  it "should belong to a site" do
    portfolios(:one).site.should == sites(:default)
  end
    
  it "should be convertible to liquid" do
    portfolios(:one).to_liquid.should be_an_instance_of(PortfolioDrop)
  end
  
  describe "relationship to assets" do
    define_models :portfolio
    
    it "should have a collection of assigned assets" do
      portfolios(:one).assigned_assets.sort_by(&:id).should == [assigned_assets(:one), assigned_assets(:two)].sort_by(&:id)
    end

    it "should have a collection of assets through the assigned assets" do
      portfolios(:one).assets.sort_by(&:id).should == [assets(:one), assets(:two)].sort_by(&:id)
    end
    
    it "should destroy the assigned assets when being destroyed" do
      lambda { portfolios(:one).destroy }.should change(AssignedAsset, :count).by(-2)
    end
    
    it "should not include assigned assets with the wrong marker" do
      portfolios(:one).assigned_assets.include?(assigned_assets(:tre)).should be_false
    end
  end
  
  describe "as nested set" do
    define_models :portfolio

    before(:each) do
      @a = Portfolio.create(:title => 'hey')
      @b = Portfolio.create(:title => 'bye')
      @b.move_to_child_of(@a)      
    end
    
    it "should allow addition of children" do
      @a.children.should == [@b]
    end
    
    it "should destroy the children when the parent is destroyed" do
      lambda { @a.destroy }.should change(Portfolio, :count).by(-2)
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe Portfolio do
  
  define_models :portfolio do
    model Portfolio do
      stub :one, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 4
    end
    model Asset do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
      stub :tre, :site => all_stubs(:site)
    end
    model AssignedAsset do
      stub :one, :asset => all_stubs(:one_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio', :position => 1
      stub :two, :asset => all_stubs(:two_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio', :position => 3
      stub :tre, :asset => all_stubs(:tre_asset), :asset_holder => all_stubs(:one_portfolio), :asset_holder_type => 'Portfolio', :position => 2
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
      title = ''
      101.times { title << 'a' }
      @portfolio.title = title
      @portfolio.should have(1).error_on(:title)
    end
    
    it "should be valid" do
      title = ''
      100.times { title << 'a' }
      @portfolio.title = title
      @portfolio.should be_valid
    end
  end
  
  it "should belong to a site" do
    portfolios(:one).site.should == sites(:default)
  end
    
  it "should be convertible to liquid" do
    portfolios(:one).to_liquid.should be_an_instance_of(PortfolioDrop)
  end

  it "should convert its text column to html on save" do
    portfolios(:one).update_attribute(:body, 'abc')
    portfolios(:one).reload.body_html.should == '<p>abc</p>'
  end
  
  describe "relationship to assets" do
    define_models :portfolio
    
    it "should have a collection of assigned assets" do
      portfolios(:one).assigned_assets.sort_by(&:id).should == [assigned_assets(:one), assigned_assets(:two), assigned_assets(:tre)].sort_by(&:id)
    end

    it "should order the assigned assets by position" do
      portfolios(:one).assigned_assets.should == [assigned_assets(:one), assigned_assets(:tre), assigned_assets(:two)]
    end

    it "should have a collection of assets through the assigned assets" do
      portfolios(:one).assets.sort_by(&:id).should == [assets(:one), assets(:two), assets(:tre)].sort_by(&:id)
    end
    
    it "should order the assets by position" do
      portfolios(:one).assets.should == [assets(:one), assets(:tre), assets(:two)]
    end
    
    it "should destroy the assigned assets when being destroyed" do
      lambda { portfolios(:one).destroy }.should change(AssignedAsset, :count).by(-3)
    end
    
    it "should allow reordering of the assigned assets" do
      portfolios(:one).assigned_assets.reorder!([assigned_assets(:one).id, assigned_assets(:two).id, assigned_assets(:tre).id])
      portfolios(:one).assigned_assets.reload.should == [assigned_assets(:one), assigned_assets(:two), assigned_assets(:tre)]
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
  
  describe "reordering" do
    define_models :portfolio

    before(:each) do
      @a = Portfolio.create(:title => 'a')
      @b = Portfolio.create(:title => 'b')
      @c = Portfolio.create(:title => 'c')
      @d = Portfolio.create(:title => 'd')
      @b.move_to_child_of(@a)
      @c.move_to_child_of(@a)
      @d.move_to_child_of(@a)
    end

    it "should have the correct initial order" do
      @a.children.should == [@b, @c, @d]
    end
    
    it "should reorder by id" do
      @a.reorder_children!([@d.id, @b.id, @c.id])
      @a.children.should == [@d, @b, @c]
    end
    
    it "should skip bad data" do
      @e = Portfolio.create(:title => 'e')
      @a.reorder_children!([@d.id, @b.id, @e.id, @c.id])
      @a.children.should == [@d, @b, @c]
    end
    
    it "should work properly when the order is the same" do
      @a.reorder_children!([@b.id, @c.id, @d.id])
      @a.children.should == [@b, @c, @d]
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe PortfolioDrop do
  define_models :portfolio_drop do
    model Asset do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :title => 'a_title', :body => 'a_body', :body_html => 'ack', :lft => 1, :rgt => 2, 
        :cover_image_file_name => 'f.png', :cover_image_content_type => 'c', :cover_image_file_size => 1, :cover_image_updated_at => Time.now
      stub :two, :site => all_stubs(:site), :title => 'a_title', :body => 'a_body', :body_html => 'ack', :lft => 3, :rgt => 4
      stub :tre, :site => all_stubs(:site), :title => 'a_title', :body => 'a_body', :body_html => 'ack', :lft => 5, :rgt => 6
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
  
  it "should provide access to the body by returning the body_html" do
    @drop.body.should == portfolios(:one).body_html
  end
  
  it "should provide access to the assets" do
    @drop.assets.should == portfolios(:one).assigned_assets.collect { |aa| AssetDrop.new(aa.asset, portfolios(:one)) }
  end
  
  it "should have a method for getting the url of the portfolio" do
    @drop.url.should == "/portfolios/#{portfolios(:one).to_param}"
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
  
  it "should provide access to the cover image" do
    @drop.should have_attached_image(:cover_image, :cover_image)
  end
end

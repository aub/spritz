require File.dirname(__FILE__) + '/../spec_helper'

describe PortfolioDrop do
  define_models :portfolio_drop do
    model Portfolio do
      stub :one, :site => all_stubs(:site), :title => 'a_title', :body => 'a_body'
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
end

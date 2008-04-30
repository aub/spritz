require File.dirname(__FILE__) + '/../spec_helper'

describe Portfolio do
  
  define_models :portfolio do
    model Portfolio do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  before(:each) do
    @portfolio = Portfolio.new
  end

  it "should be valid" do
    @portfolio.should be_valid
  end
  
  it "should belong to a site" do
    portfolios(:one).site.should == sites(:default)
  end
end

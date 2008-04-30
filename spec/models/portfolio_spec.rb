require File.dirname(__FILE__) + '/../spec_helper'

describe Portfolio do
  
  define_models :portfolio do
    model Portfolio do
      stub :one, :site => all_stubs(:site)
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
  end
  
  it "should belong to a site" do
    portfolios(:one).site.should == sites(:default)
  end
end

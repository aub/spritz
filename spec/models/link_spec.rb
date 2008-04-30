require File.dirname(__FILE__) + '/../spec_helper'

describe Link do

  define_models :link do
    model Link do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  describe "validations" do
    before(:each) do
      @link = Link.new
    end

    it "should be valid" do
      @link.should be_valid
    end
  end
  
  it "should be convertible to liquid" do
    links(:one).to_liquid.should be_a_kind_of(BaseDrop)
  end
  
  it "should belong to a site" do
    links(:one).site.should == sites(:default)
  end
end

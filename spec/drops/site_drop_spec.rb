require File.dirname(__FILE__) + '/../spec_helper'

describe SiteDrop do
  define_models :site_drop do
  end
  
  before(:each) do
    @drop = SiteDrop.new(sites(:default))
  end
    
  it "should provide access to the title" do
    @drop.before_method('title').should == sites(:default).title
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe SiteDrop do
  define_models :site_drop do
    model Section do
      stub :one, :site => all_stubs(:site), :position => 3, :active => true
      stub :two, :site => all_stubs(:site), :position => 1, :active => true
      stub :tre, :site => all_stubs(:site), :position => 2, :active => false
    end
  end
  
  before(:each) do
    @drop = SiteDrop.new(sites(:default))
  end
    
  it "should provide access to the title" do
    @drop.before_method('title').should == sites(:default).title
  end
  
  it "should provide access to the active sections" do
    @drop.sections.should == [sections(:one), sections(:two)].sort_by(&:position).collect(&:to_liquid)
  end
  
end

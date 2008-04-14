require File.dirname(__FILE__) + '/../spec_helper'

describe Section do
  define_models :site_drop do
    model Section do
      stub :one, :site => all_stubs(:site), :position => 3, :active => true, :name => 'name-o'
    end
  end
  
  before(:each) do
    @drop = SectionDrop.new(sections(:one))
  end
    
  it "should provide access to the name" do
    @drop.before_method('name').should == sections(:one).name
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

class HackSection < Section
end

describe Section do
  define_models :section do
    model Section do
      stub :one, :site => all_stubs(:site), :name => 'Hooya'
    end
  end
  
  describe "validations" do
    define_models :section
    
    before(:each) do
      @section = Section.new
    end
    
    it "should not be valid" do
      @section.should_not be_valid
    end
    
    it "should require a name" do
      @section.should have(1).error_on(:name)
    end
    
    it "should require a unique name" do
      @section.site_id = sections(:one).site_id
      @section.name = sections(:one).name
      @section.should have(1).error_on(:name)
    end
    
    it "should allow the same name in different sites" do
      @section.name = sections(:one).name
      @section.site_id = sections(:one).site_id + 1
      @section.should have(0).errors_on(:name)
    end
    
    it "should require a site" do
      @section.should have(1).error_on(:site_id)
    end
  end
  
  describe "relationship to sites" do
    define_models :section
    
    it "should belong to one" do
      sections(:one).site.should == sites(:default)
    end
  end  
  
  describe "liquid conversion" do
    define_models :section
    
    it "should be possible" do
      sections(:one).to_liquid.should be_a_kind_of(BaseDrop)
    end
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

class HackSection < Section
end

describe Section do
  define_models :section do
    model Section do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  describe "relationship to sites" do
    define_models :section
    
    it "should belong to one" do
      sections(:one).site.should == sites(:default)
    end
  end  
end

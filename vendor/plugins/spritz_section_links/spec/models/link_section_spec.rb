require File.dirname(__FILE__) + '/../spec_helper'

describe LinkSection do
  define_models :link_section do
    model LinkSection do
      stub :elvis
    end
    model Link do
      stub :one, :section => all_stubs(:elvis_link_section), :url => 'www.junk.com'
      stub :two, :section => all_stubs(:elvis_link_section), :url => 'www.foo.com'
    end
  end  
  
  describe "relationship to links" do
    define_models :link_section
    
    it "should have many" do
      link_sections(:elvis).links.sort_by(&:id).should == [links(:one), links(:two)].sort_by(&:id)
    end
  end
end
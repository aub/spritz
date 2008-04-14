require File.dirname(__FILE__) + '/../spec_helper'

describe Link do
  define_models :link do
    model LinkSection do
      stub :elvis
    end
    model Link do
      stub :one, :section => all_stubs(:elvis_link_section), :url => 'www.junk.com'
    end
  end
  
  describe "relationship to the link section" do
    define_models :link
    
    it "should belong to one" do
      links(:one).section.should == link_sections(:elvis)
    end
  end
end
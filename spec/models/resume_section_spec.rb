require File.dirname(__FILE__) + '/../spec_helper'

describe ResumeSection do
  
  define_models :resume_section do
    model ResumeSection do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  describe "validations" do
    before(:each) do
      @resume_section = ResumeSection.new
    end

    it "should require a title" do
      @resume_section.should have(1).error_on(:title)
    end

    it "should be valid" do
      @resume_section.title = 'ack'
      @resume_section.should be_valid
    end
  end
  
  describe "relationship to the site" do
    define_models :resume_section
    
    it "should belong to a site" do
      resume_sections(:one).site.should == sites(:default)
    end
  end
end

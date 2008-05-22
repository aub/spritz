require File.dirname(__FILE__) + '/../spec_helper'

describe ResumeItem do
  define_models :resume_item do
    model ResumeSection do
      stub :one, :site => all_stubs(:site)
    end
    model ResumeItem do
      stub :one, :resume_section => all_stubs(:one_resume_section)
    end
  end
  
  describe "validations" do
    before(:each) do
      @resume_item = ResumeItem.new
    end

    it "should require some text" do
      @resume_item.should have(1).error_on(:text)
    end

    it "should be valid" do
      @resume_item.text = 'test'
      @resume_item.should be_valid
    end
  end
  
  it "should belong to a resume section" do
    resume_items(:one).resume_section.should == resume_sections(:one)
  end
end

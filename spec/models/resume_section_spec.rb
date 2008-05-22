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
  
  describe "relationship to resume items" do
    define_models :resume_section do
      model ResumeSection do
        stub :one, :site => all_stubs(:site)
      end
      model ResumeItem do
        stub :one, :resume_section => all_stubs(:one_resume_section), :position => 2
        stub :two, :resume_section => all_stubs(:one_resume_section), :position => 1
        stub :tre, :resume_section => all_stubs(:one_resume_section), :position => 3
      end
    end
    
    it "should have a collection of resume items" do
      resume_sections(:one).resume_items.sort_by(&:id).should == ResumeItem.find_all_by_resume_section_id(resume_sections(:one).id).sort_by(&:id)
    end

    it "should order the resume items by position" do
      resume_sections(:one).resume_items.should == [resume_items(:two), resume_items(:one), resume_items(:tre)]
    end
    
    it "should destroy the resume items when destroyed" do
      lambda { resume_sections(:one).destroy }.should change(ResumeItem, :count).by(-3)
    end
    
    it "should allow reordering of the resume items" do
      resume_sections(:one).resume_items.reorder!([resume_items(:one).id, resume_items(:two).id, resume_items(:tre).id])
      resume_sections(:one).resume_items.should == [resume_items(:one), resume_items(:two), resume_items(:tre)]
    end
  end  
end

require File.dirname(__FILE__) + '/../spec_helper'

describe ResumeSectionDrop do
  define_models :resume_section_drop do
    model ResumeSection do
      stub :one, :site => all_stubs(:site), :title => 'a_title'
    end
    model ResumeItem do
      stub :one, :resume_section => all_stubs(:one_resume_section), :text => 'a', :position => 2
      stub :two, :resume_section => all_stubs(:one_resume_section), :text => 'a', :position => 1
    end
  end
  
  before(:each) do
    @drop = ResumeSectionDrop.new(resume_sections(:one))
  end
    
  it "should provide access to the title" do
    @drop.before_method('title').should == 'a_title'
  end
  
  it "should provide access to the items" do
    @drop.items.should == [resume_items(:two), resume_items(:one)].collect(&:to_liquid)
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe ResumeSectionDrop do
  define_models :resume_section_drop do
    model ResumeSection do
      stub :one, :site => all_stubs(:site), :title => 'a_title'
    end
  end
  
  before(:each) do
    @drop = ResumeSectionDrop.new(resume_sections(:one))
  end
    
  it "should provide access to the title" do
    @drop.before_method('title').should == 'a_title'
  end
end

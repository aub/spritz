require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/resume_sections/new.html.haml" do
  include Admin::ResumeSectionsHelper
  
  before(:each) do
    @resume_section = mock_model(ResumeSection)
    @resume_section.stub!(:new_record?).and_return(true)
    @resume_section.stub!(:title).and_return("MyString")
    @resume_section.stub!(:site_id).and_return("1")
    assigns[:resume_section] = @resume_section
  end

  it "should render new form" do
    render "/admin/resume_sections/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", admin_resume_sections_path) do
      with_tag("input#resume_section_title[name=?]", "resume_section[title]")
    end
  end
end



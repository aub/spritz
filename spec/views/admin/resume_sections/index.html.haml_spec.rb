require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/resume_sections/index.html.haml" do
  include Admin::ResumeSectionsHelper
  
  before(:each) do
    resume_section_98 = mock_model(ResumeSection)
    resume_section_98.should_receive(:title).and_return("MyString")
    resume_section_99 = mock_model(ResumeSection)
    resume_section_99.should_receive(:title).and_return("MyString")

    assigns[:resume_sections] = [resume_section_98, resume_section_99]
  end

  it "should render list of admin_resume_sections" do
    render "/admin/resume_sections/index.html.haml"
    response.should have_tag("tr>td", "MyString", 2)
  end
end


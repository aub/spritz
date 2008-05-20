require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/resume_sections/edit.html.haml" do
  include Admin::ResumeSectionsHelper
  
  before do
    @resume_section = mock_model(ResumeSection)
    @resume_section.stub!(:title).and_return("MyString")
    @resume_section.stub!(:site_id).and_return("1")
    assigns[:resume_section] = @resume_section
  end

  it "should render edit form" do
    render "/admin/resume_sections/edit.html.haml"
    
    response.should have_tag("form[action=#{admin_resume_section_path(@resume_section)}][method=post]") do
      with_tag('input#resume_section_title[name=?]', "resume_section[title]")
    end
  end
end



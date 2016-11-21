require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/resume_items/new.html.haml" do
  include Admin::ResumeItemsHelper
  
  before(:each) do
    @resume_item = mock_model(ResumeItem)
    @resume_item.stub!(:new_record?).and_return(true)
    @resume_item.stub!(:text).and_return("MyText")
    assigns[:resume_item] = @resume_item
    
    @resume_section = mock_model(ResumeSection)
    assigns[:resume_section] = @resume_section
  end

  it "should render new form" do
    render "/admin/resume_items/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", admin_resume_section_resume_items_path(@resume_section)) do
      with_tag("textarea#resume_item_text[name=?]", "resume_item[text]")
    end
  end
end



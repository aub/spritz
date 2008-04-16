require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sections/index.html.haml" do
  include Admin::SectionsHelper
  
  before(:each) do
    @section_type1 = mock_model(Hash, :name => 'ack', :section_name => 'section_type1', :admin_controller => 'admin/users')
    @section_type2 = mock_model(Hash, :name => 'ack', :section_name => 'section_type2', :admin_controller => 'admin/sites')
    assigns[:available_section_types] = [@section_type1, @section_type2]
    
    @section1 = mock_model(Section, :name => 'ack', :section_name => 'section1', :admin_controller => 'admin/users')
    @section2 = mock_model(Section, :name => 'ack', :section_name => 'section2', :admin_controller => 'admin/sites')
    assigns[:sections] = [@section1, @section2]
    render "/admin/sections/index.html.haml"
  end

  it "should have links for making a new section of each type" do
    response.should have_tag('a[href=?]', admin_sections_path(:name => @section_type1.section_name))
    response.should have_tag('a[href=?]', admin_sections_path(:name => @section_type2.section_name))
  end

  it "should have links for editing the existing sections" do
    response.should have_tag('a[href=?]', admin_user_path(@section1))
    response.should have_tag('a[href=?]', admin_site_path(@section2))
  end
  
end
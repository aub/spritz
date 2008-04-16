require File.dirname(__FILE__) + '/../spec_helper'

describe Spritz::Plugin do
  
  def any_plugin
    Engines.plugins.first
  end
  
  it "should allow clearing of the section types" do
    Spritz::Plugin.add_section_type(Section)
    Spritz::Plugin.clear_section_types
    Spritz::Plugin.section_types.should == []
  end
  
  it "should allow adding of a section" do
    Spritz::Plugin.clear_section_types
    a = Section
    Spritz::Plugin.add_section_type(a)
    Spritz::Plugin.section_types.should == [Section]
  end  
end

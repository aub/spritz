require File.dirname(__FILE__) + '/../spec_helper'

describe Spritz::Plugin do
  
  def any_plugin
    Engines.plugins.first
  end
  
  it "should allow adding of a section" do
    Spritz::Plugin.section_types.clear
    a = 'link'
    any_plugin.add_section_type(a)
    Spritz::Plugin.section_types.should == [a]
  end  
end

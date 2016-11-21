require File.dirname(__FILE__) + '/../spec_helper'

describe ResumeItemDrop do
  define_models :resume_item_drop do
    model ResumeItem do
      stub :one, :text => 'a', :text_html => 'ack', :position => 2
    end
  end
  
  before(:each) do
    @drop = ResumeItemDrop.new(resume_items(:one))
  end
    
  it "should provide access to the text as the text_html" do
    @drop.text.should == 'ack'
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe LinkDrop do
  define_models :link_drop do
    model Link do
      stub :one, :site => all_stubs(:site), :url => 'a_url', :title => 'a_title'
    end
  end
  
  before(:each) do
    @drop = LinkDrop.new(links(:one))
  end
    
  it "should provide access to the title" do
    @drop.before_method('title').should == links(:one).title
  end
  
  it "should provide access to the url" do
    @drop.before_method('url').should == links(:one).url
  end
end

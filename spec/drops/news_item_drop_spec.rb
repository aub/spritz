require File.dirname(__FILE__) + '/../spec_helper'

describe NewsItemDrop do
  define_models :news_item_drop do
    model NewsItem do
      stub :one, :site => all_stubs(:site), :text => 'a bit of text', :title => 'a_title'
    end
  end
  
  before(:each) do
    @drop = NewsItemDrop.new(news_items(:one))
  end
    
  it "should provide access to the title" do
    @drop.before_method('title').should == news_items(:one).title
  end
  
  it "should provide access to the text" do
    @drop.before_method('text').should == news_items(:one).text
  end
end

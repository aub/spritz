require File.dirname(__FILE__) + '/../spec_helper'

describe NewsItem do
  define_models :news_items do
    model NewsItem do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  describe "validations" do
    before(:each) do
      @news_item = NewsItem.new
    end

    it "should require a title" do
      @news_item.should_not be_valid
      @news_item.should have(2).errors_on(:title)
    end
    
    it "should limit the length of the title" do
      @news_item.title = '123456789012345678901234567890123456789012345678901'
      @news_item.should have(1).error_on(:title)
    end

    it "should be valid" do
      @news_item.title = 'I got a show!'
      @news_item.should be_valid
    end
  end
  
  describe "relationship to the site" do
    define_models :news_items
    
    it "should belong to a site" do
      news_items(:one).site.should == sites(:default)
    end
  end
  
  it "should convert its text column to html on save" do
    news_items(:one).update_attribute(:text, 'abc')
    news_items(:one).reload.text_html.should == '<p>abc</p>'
  end
  
  it "should be convertible to liquid" do
    NewsItem.new.to_liquid.should be_an_instance_of(NewsItemDrop)
  end
end

require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/news_items/edit.html.haml" do
  include Admin::NewsItemsHelper
  
  before do
    @news_item = mock_model(NewsItem)
    @news_item.stub!(:title).and_return("MyString")
    @news_item.stub!(:text).and_return("MyText")
    assigns[:news_item] = @news_item
  end

  it "should render edit form" do
    render "/admin/news_items/edit.html.haml"
    
    response.should have_tag("form[action=#{admin_news_item_path(@news_item)}][method=post]") do
      with_tag('input#news_item_title[name=?]', "news_item[title]")
      with_tag('textarea#news_item_text[name=?]', "news_item[text]")
    end
  end
end



require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/news_items/index.html.haml" do
  include Admin::NewsItemsHelper
  
  before(:each) do
    news_item_98 = mock_model(NewsItem)
    news_item_98.should_receive(:title).and_return("MyString")
    news_item_99 = mock_model(NewsItem)
    news_item_99.should_receive(:title).and_return("MyString")

    assigns[:news_items] = [news_item_98, news_item_99]
  end

  it "should render list of news_items" do
    render "/admin/news_items/index.html.haml"
  end
end


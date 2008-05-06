require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/home/edit.html.haml" do
  include Admin::HomeHelper
  
  before do
    @site = mock_model(Site)
    @site.stub!(:home_text).and_return("MyString")
    @site.stub!(:home_news_item_count).and_return(3)
    assigns[:site] = @site
  end

  it "should render edit form" do
    render "/admin/home/edit.html.haml"
    
    response.should have_tag("form[action=#{admin_home_path}][method=post]") do
      with_tag('textarea#site_home_text[name=?]', "site[home_text]")
      with_tag('select#site_home_news_item_count[name=?]', "site[home_news_item_count]")
    end
  end
end



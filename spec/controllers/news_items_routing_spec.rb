require File.dirname(__FILE__) + '/../spec_helper'

describe NewsItemsController do
  describe "route generation" do

    it "should map { :controller => 'news_items', :action => 'index' } to /news_items" do
      route_for(:controller => "news_items", :action => "index").should == "/news_items"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'news_items', action => 'index' } from GET /news_items" do
      params_from(:get, "/news_items").should == {:controller => "news_items", :action => "index"}
    end
  end
end
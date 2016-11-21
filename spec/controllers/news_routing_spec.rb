require File.dirname(__FILE__) + '/../spec_helper'

describe NewsController do
  describe "route generation" do

    it "should map { :controller => 'news', :action => 'show' } to /news" do
      route_for(:controller => "news", :action => "show").should == "/news"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'news', action => 'show' } from GET /news" do
      params_from(:get, "/news").should == {:controller => "news", :action => "show"}
    end
  end
end
require File.dirname(__FILE__) + '/../spec_helper'

describe LinksController do
  describe "route generation" do

    it "should map { :controller => 'links', :action => 'show' } to /links" do
      route_for(:controller => "links", :action => "show").should == "/links"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'links', action => 'show' } from GET /links" do
      params_from(:get, "/links").should == {:controller => "links", :action => "show"}
    end
  end
end
require File.dirname(__FILE__) + '/../spec_helper'

describe LinksController do
  describe "route generation" do

    it "should map { :controller => 'links', :action => 'index' } to /links" do
      route_for(:controller => "links", :action => "index").should == "/links"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'links', action => 'index' } from GET /links" do
      params_from(:get, "/links").should == {:controller => "links", :action => "index"}
    end
  end
end
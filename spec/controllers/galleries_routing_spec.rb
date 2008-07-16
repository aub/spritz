require File.dirname(__FILE__) + '/../spec_helper'

describe GalleriesController do
  describe "route generation" do

    it "should map { :controller => 'galleries', :action => 'show' } to /galleries" do
      route_for(:controller => "galleries", :action => "show").should == "/galleries"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'galleries', action => 'show' } from GET /galleries" do
      params_from(:get, "/galleries").should == {:controller => "galleries", :action => "show"}
    end
  end
end
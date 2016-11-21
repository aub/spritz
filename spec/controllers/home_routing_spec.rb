require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController do
  describe "route generation" do

    it "should map { :controller => 'home', :action => 'show' } to /" do
      route_for(:controller => "home", :action => "show").should == "/"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'home', action => 'show' } from GET /" do
      params_from(:get, "/").should == {:controller => "home", :action => "show"}
    end
  end
end
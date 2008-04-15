require File.dirname(__FILE__) + '/../spec_helper'

describe DispatchController do
  describe "route generation" do

    it "should map { :controller => 'dispatch', :action => 'dispatch', :path => ['a', 'b', 'c'] } to /a/b/c" do
      route_for(:controller => "dispatch", :action => "dispatch", :path => ['a', 'b', 'c']).should == "/a/b/c"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'dispatch', action => 'dispatch', :path => ['a', 'b', 'c'] } from GET /a/b/c" do
      params_from(:get, "/a/b/c").should == {:controller => "dispatch", :action => "dispatch", :path => ['a', 'b', 'c']}
    end
  end
end
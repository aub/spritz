require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::DashboardController do
  describe "route generation" do

    it "should map { :controller => 'admin/dashboard', :action => 'show' } to /admin/dashboard" do
      route_for(:controller => "admin/dashboard", :action => "show").should == "/admin/dashboard"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/dashboard', action => 'show' } from GET /admin/dashboard" do
      params_from(:get, "/admin/dashboard").should == {:controller => "admin/dashboard", :action => "show"}
    end
  end
end
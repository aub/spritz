require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::DashboardController do
  describe "route generation" do

    # This is confused by the fact that the dashboard is at two locations /admin and /admin/dashboard
    it "should map { :controller => 'admin/dashboard', :action => 'show' } to /admin" do
      route_for(:controller => "admin/dashboard", :action => "show").should == "/admin"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/dashboard', action => 'show' } from GET /admin/dashboard" do
      params_from(:get, "/admin/dashboard").should == {:controller => "admin/dashboard", :action => "show"}
    end
    
    it "should generate params { :controller => 'admin/dashboard', action => 'show' } from GET /admin" do
      params_from(:get, "/admin").should == {:controller => "admin/dashboard", :action => "show"}
    end
  end
end
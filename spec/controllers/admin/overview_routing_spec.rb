require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SitesController do
  describe "route generation" do

    it "should map { :controller => 'admin/overview', :action => 'show' } to /admin" do
      route_for(:controller => "admin/overview", :action => "show").should == "/admin"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/overview', action => 'show' } from GET /admin" do
      params_from(:get, "/admin").should == {:controller => "admin/overview", :action => "show"}
    end
  end
end
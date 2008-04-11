require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SettingsController do
  describe "route generation" do

    it "should map { :controller => 'admin/settings', :action => 'show' } to /admin/settings" do
      route_for(:controller => "admin/settings", :action => "show").should == "/admin/settings"
    end
  
    it "should map { :controller => 'admin/settings', :action => 'edit' } to /admin/settings/edit" do
      route_for(:controller => "admin/settings", :action => "edit").should == "/admin/settings/edit"
    end
  
    it "should map { :controller => 'admin/settings', :action => 'update' } to /admin/settings" do
      route_for(:controller => "admin/settings", :action => "update").should == "/admin/settings"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/settings', action => 'show' } from GET /admin/settings" do
      params_from(:get, "/admin/settings").should == {:controller => "admin/settings", :action => "show"}
    end
  
    it "should generate params { :controller => 'admin/settings', action => 'new' } from GET /admin/settings/edit" do
      params_from(:get, "/admin/settings/edit").should == {:controller => "admin/settings", :action => "edit"}
    end
  
    it "should generate params { :controller => 'admin/settings', action => 'update' } from POST /admin/settings" do
      params_from(:put, "/admin/settings").should == {:controller => "admin/settings", :action => "update"}
    end
  end
end
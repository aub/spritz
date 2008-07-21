require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SettingsController do
  describe "route generation" do

    it "should map { :controller => 'admin/settings', :action => 'edit' } to /admin/settings/edit" do
      route_for(:controller => "admin/settings", :action => "edit").should == "/admin/settings/edit"
    end
  
    it "should map { :controller => 'admin/settings', :action => 'update' } to /admin/settings" do
      route_for(:controller => "admin/settings", :action => "update").should == "/admin/settings"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/settings', action => 'edit' } from GET /admin/settings/edit" do
      params_from(:get, "/admin/settings/edit").should == {:controller => "admin/settings", :action => "edit"}
    end
  
    it "should generate params { :controller => 'admin/settings', action => 'update' } from PUT /admin/settings" do
      params_from(:put, "/admin/settings").should == {:controller => "admin/settings", :action => "update"}
    end
  end
end
require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SitesController do
  describe "route generation" do

    it "should map { :controller => 'admin/sites', :action => 'index' } to /admin/sites" do
      route_for(:controller => "admin/sites", :action => "index").should == "/admin/sites"
    end
  
    it "should map { :controller => 'admin/sites', :action => 'new' } to /admin/sites/new" do
      route_for(:controller => "admin/sites", :action => "new").should == "/admin/sites/new"
    end
  
    it "should map { :controller => 'admin/sites', :action => 'show', :id => 1 } to /admin/sites/1" do
      route_for(:controller => "admin/sites", :action => "show", :id => 1).should == "/admin/sites/1"
    end
  
    it "should map { :controller => 'admin/sites', :action => 'edit', :id => 1 } to /admin/sites/1/edit" do
      route_for(:controller => "admin/sites", :action => "edit", :id => 1).should == "/admin/sites/1/edit"
    end
  
    it "should map { :controller => 'admin/sites', :action => 'update', :id => 1} to /admin/sites/1" do
      route_for(:controller => "admin/sites", :action => "update", :id => 1).should == "/admin/sites/1"
    end
  
    it "should map { :controller => 'admin/sites', :action => 'destroy', :id => 1} to /admin/sites/1" do
      route_for(:controller => "admin/sites", :action => "destroy", :id => 1).should == "/admin/sites/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/sites', action => 'index' } from GET /admin/sites" do
      params_from(:get, "/admin/sites").should == {:controller => "admin/sites", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/sites', action => 'new' } from GET /admin/sites/new" do
      params_from(:get, "/admin/sites/new").should == {:controller => "admin/sites", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/sites', action => 'create' } from POST /admin/sites" do
      params_from(:post, "/admin/sites").should == {:controller => "admin/sites", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/sites', action => 'show', id => '1' } from GET /admin/sites/1" do
      params_from(:get, "/admin/sites/1").should == {:controller => "admin/sites", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/sites', action => 'edit', id => '1' } from GET /admin/sites/1;edit" do
      params_from(:get, "/admin/sites/1/edit").should == {:controller => "admin/sites", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/sites', action => 'update', id => '1' } from PUT /admin/sites/1" do
      params_from(:put, "/admin/sites/1").should == {:controller => "admin/sites", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/sites', action => 'destroy', id => '1' } from DELETE /admin/sites/1" do
      params_from(:delete, "/admin/sites/1").should == {:controller => "admin/sites", :action => "destroy", :id => "1"}
    end
  end
end
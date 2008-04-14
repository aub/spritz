require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SectionsController do
  describe "route generation" do

    it "should map { :controller => 'admin/sections', :action => 'index' } to /admin/sections" do
      route_for(:controller => "admin/sections", :action => "index").should == "/admin/sections"
    end
  
    it "should map { :controller => 'admin/sections', :action => 'new' } to /admin/sections/new" do
      route_for(:controller => "admin/sections", :action => "new").should == "/admin/sections/new"
    end
  
    it "should map { :controller => 'admin/sections', :action => 'show', :id => 1 } to /admin/sections/1" do
      route_for(:controller => "admin/sections", :action => "show", :id => 1).should == "/admin/sections/1"
    end
  
    it "should map { :controller => 'admin/sections', :action => 'edit', :id => 1 } to /admin/sections/1/edit" do
      route_for(:controller => "admin/sections", :action => "edit", :id => 1).should == "/admin/sections/1/edit"
    end
  
    it "should map { :controller => 'admin/sections', :action => 'update', :id => 1} to /admin/sections/1" do
      route_for(:controller => "admin/sections", :action => "update", :id => 1).should == "/admin/sections/1"
    end
  
    it "should map { :controller => 'admin/sections', :action => 'destroy', :id => 1} to /admin/sections/1" do
      route_for(:controller => "admin/sections", :action => "destroy", :id => 1).should == "/admin/sections/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/sections', action => 'index' } from GET /admin/sections" do
      params_from(:get, "/admin/sections").should == {:controller => "admin/sections", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/sections', action => 'new' } from GET /admin/sections/new" do
      params_from(:get, "/admin/sections/new").should == {:controller => "admin/sections", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/sections', action => 'create' } from POST /admin/sections" do
      params_from(:post, "/admin/sections").should == {:controller => "admin/sections", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/sections', action => 'show', id => '1' } from GET /admin/sections/1" do
      params_from(:get, "/admin/sections/1").should == {:controller => "admin/sections", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/sections', action => 'edit', id => '1' } from GET /admin/sections/1;edit" do
      params_from(:get, "/admin/sections/1/edit").should == {:controller => "admin/sections", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/sections', action => 'update', id => '1' } from PUT /admin/sections/1" do
      params_from(:put, "/admin/sections/1").should == {:controller => "admin/sections", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/sections', action => 'destroy', id => '1' } from DELETE /admin/sections/1" do
      params_from(:delete, "/admin/sections/1").should == {:controller => "admin/sections", :action => "destroy", :id => "1"}
    end
  end
end
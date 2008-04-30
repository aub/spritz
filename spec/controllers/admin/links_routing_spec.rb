require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::LinksController do
  describe "route generation" do

    it "should map { :controller => 'admin/links', :action => 'index' } to /links" do
      route_for(:controller => "admin/links", :action => "index").should == "/admin/links"
    end
  
    it "should map { :controller => 'admin/links', :action => 'new' } to /links/new" do
      route_for(:controller => "admin/links", :action => "new").should == "/admin/links/new"
    end

    it "should map { :controller => 'admin/links', :action => 'create' } to /links" do
      route_for(:controller => "admin/links", :action => "create").should == "/admin/links"
    end
  
    it "should map { :controller => 'admin/links', :action => 'show', :id => 1 } to /links/1" do
      route_for(:controller => "admin/links", :action => "show", :id => 1).should == "/admin/links/1"
    end
  
    it "should map { :controller => 'admin/links', :action => 'edit', :id => 1 } to /links/1/edit" do
      route_for(:controller => "admin/links", :action => "edit", :id => 1).should == "/admin/links/1/edit"
    end
  
    it "should map { :controller => 'admin/links', :action => 'update', :id => 1} to /links/1" do
      route_for(:controller => "admin/links", :action => "update", :id => 1).should == "/admin/links/1"
    end
  
    it "should map { :controller => 'admin/links', :action => 'destroy', :id => 1} to /links/1" do
      route_for(:controller => "admin/links", :action => "destroy", :id => 1).should == "/admin/links/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/links', action => 'index' } from GET /links" do
      params_from(:get, "/admin/links").should == {:controller => "admin/links", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/links', action => 'new' } from GET /links/new" do
      params_from(:get, "/admin/links/new").should == {:controller => "admin/links", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/links', action => 'create' } from POST /links" do
      params_from(:post, "/admin/links").should == {:controller => "admin/links", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/links', action => 'show', id => '1' } from GET /links/1" do
      params_from(:get, "/admin/links/1").should == {:controller => "admin/links", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/links', action => 'edit', id => '1' } from GET /links/1;edit" do
      params_from(:get, "/admin/links/1/edit").should == {:controller => "admin/links", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/links', action => 'update', id => '1' } from PUT /links/1" do
      params_from(:put, "/admin/links/1").should == {:controller => "admin/links", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/links', action => 'destroy', id => '1' } from DELETE /links/1" do
      params_from(:delete, "/admin/links/1").should == {:controller => "admin/links", :action => "destroy", :id => "1"}
    end
  end
end
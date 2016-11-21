require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::GalleriesController do
  describe "route generation" do

    it "should map { :controller => 'admin/galleries', :action => 'index' } to /admin/galleries" do
      route_for(:controller => "admin/galleries", :action => "index").should == "/admin/galleries"
    end
  
    it "should map { :controller => 'admin/galleries', :action => 'new' } to /admin/galleries/new" do
      route_for(:controller => "admin/galleries", :action => "new").should == "/admin/galleries/new"
    end
  
    it "should map { :controller => 'admin/galleries', :action => 'show', :id => 1 } to /admin/galleries/1" do
      route_for(:controller => "admin/galleries", :action => "show", :id => 1).should == "/admin/galleries/1"
    end
  
    it "should map { :controller => 'admin/galleries', :action => 'edit', :id => 1 } to /admin/galleries/1/edit" do
      route_for(:controller => "admin/galleries", :action => "edit", :id => 1).should == "/admin/galleries/1/edit"
    end
  
    it "should map { :controller => 'admin/galleries', :action => 'update', :id => 1} to /admin/galleries/1" do
      route_for(:controller => "admin/galleries", :action => "update", :id => 1).should == "/admin/galleries/1"
    end
  
    it "should map { :controller => 'admin/galleries', :action => 'destroy', :id => 1} to /admin/galleries/1" do
      route_for(:controller => "admin/galleries", :action => "destroy", :id => 1).should == "/admin/galleries/1"
    end
    
    it "should map { :controller => 'admin/galleries', :action => 'reorder'} to /admin/galleries/reorder" do
      route_for(:controller => "admin/galleries", :action => "reorder").should == "/admin/galleries/reorder"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/galleries', action => 'index' } from GET /admin/galleries" do
      params_from(:get, "/admin/galleries").should == {:controller => "admin/galleries", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/galleries', action => 'new' } from GET /admin/galleries/new" do
      params_from(:get, "/admin/galleries/new").should == {:controller => "admin/galleries", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/galleries', action => 'create' } from POST /admin/galleries" do
      params_from(:post, "/admin/galleries").should == {:controller => "admin/galleries", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/galleries', action => 'show', id => '1' } from GET /admin/galleries/1" do
      params_from(:get, "/admin/galleries/1").should == {:controller => "admin/galleries", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/galleries', action => 'edit', id => '1' } from GET /admin/galleries/1;edit" do
      params_from(:get, "/admin/galleries/1/edit").should == {:controller => "admin/galleries", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/galleries', action => 'update', id => '1' } from PUT /admin/galleries/1" do
      params_from(:put, "/admin/galleries/1").should == {:controller => "admin/galleries", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/galleries', action => 'destroy', id => '1' } from DELETE /admin/galleries/1" do
      params_from(:delete, "/admin/galleries/1").should == {:controller => "admin/galleries", :action => "destroy", :id => "1"}
    end
    
    it "should generate params { :controller => 'admin/galleries', action => 'reorder' } from PUT /admin/galleries/reorder" do
      params_from(:put, "/admin/galleries/reorder").should == {:controller => "admin/galleries", :action => "reorder"}
    end
  end
end
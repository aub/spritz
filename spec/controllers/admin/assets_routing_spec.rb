require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AssetsController do
  describe "route generation" do

    it "should map { :controller => 'admin/assets', :action => 'index' } to /admin/assets" do
      route_for(:controller => "admin/assets", :action => "index").should == "/admin/assets"
    end
  
    it "should map { :controller => 'admin/assets', :action => 'new' } to /admin/assets/new" do
      route_for(:controller => "admin/assets", :action => "new").should == "/admin/assets/new"
    end
  
    it "should map { :controller => 'admin/assets', :action => 'show', :id => 1 } to /admin/assets/1" do
      route_for(:controller => "admin/assets", :action => "show", :id => 1).should == "/admin/assets/1"
    end
  
    it "should map { :controller => 'admin/assets', :action => 'edit', :id => 1 } to /admin/assets/1/edit" do
      route_for(:controller => "admin/assets", :action => "edit", :id => 1).should == "/admin/assets/1/edit"
    end
  
    it "should map { :controller => 'admin/assets', :action => 'update', :id => 1} to /admin/assets/1" do
      route_for(:controller => "admin/assets", :action => "update", :id => 1).should == "/admin/assets/1"
    end
  
    it "should map { :controller => 'admin/assets', :action => 'destroy', :id => 1} to /admin/assets/1" do
      route_for(:controller => "admin/assets", :action => "destroy", :id => 1).should == "/admin/assets/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/assets', action => 'index' } from GET /admin/assets" do
      params_from(:get, "/admin/assets").should == {:controller => "admin/assets", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/assets', action => 'new' } from GET /admin/assets/new" do
      params_from(:get, "/admin/assets/new").should == {:controller => "admin/assets", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/assets', action => 'create' } from POST /admin/assets" do
      params_from(:post, "/admin/assets").should == {:controller => "admin/assets", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/assets', action => 'show', id => '1' } from GET /admin/assets/1" do
      params_from(:get, "/admin/assets/1").should == {:controller => "admin/assets", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/assets', action => 'edit', id => '1' } from GET /admin/assets/1;edit" do
      params_from(:get, "/admin/assets/1/edit").should == {:controller => "admin/assets", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/assets', action => 'update', id => '1' } from PUT /admin/assets/1" do
      params_from(:put, "/admin/assets/1").should == {:controller => "admin/assets", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/assets', action => 'destroy', id => '1' } from DELETE /admin/assets/1" do
      params_from(:delete, "/admin/assets/1").should == {:controller => "admin/assets", :action => "destroy", :id => "1"}
    end
  end
end
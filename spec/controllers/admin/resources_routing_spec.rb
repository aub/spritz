require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ResourcesController do
  describe "route generation" do

    it "should map { :controller => 'admin/resources', :action => 'index' } to /admin/resources" do
      route_for(:controller => "admin/resources", :action => "index").should == "/admin/resources"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'new' } to /admin/resources/new" do
      route_for(:controller => "admin/resources", :action => "new").should == "/admin/resources/new"
    end

    it "should map { :controller => 'admin/resources', :action => 'create' } to /admin/resources" do
      route_for(:controller => "admin/resources", :action => "create").should == "/admin/resources"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'show', :id => 1 } to /admin/resources/1" do
      route_for(:controller => "admin/resources", :action => "show", :id => 1).should == "/admin/resources/1"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'edit', :id => 1 } to /admin/resources/1/edit" do
      route_for(:controller => "admin/resources", :action => "edit", :id => 1).should == "/admin/resources/1/edit"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'update', :id => 1} to /admin/resources/1" do
      route_for(:controller => "admin/resources", :action => "update", :id => 1).should == "/admin/resources/1"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'destroy', :id => 1} to /admin/resources/1" do
      route_for(:controller => "admin/resources", :action => "destroy", :id => 1).should == "/admin/resources/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/resources', action => 'index' } from GET /admin/resources" do
      params_from(:get, "/admin/resources").should == {:controller => "admin/resources", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'new' } from GET /admin/resources/new" do
      params_from(:get, "/admin/resources/new").should == {:controller => "admin/resources", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'create' } from POST /admin/resources" do
      params_from(:post, "/admin/resources").should == {:controller => "admin/resources", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'show', id => '1' } from GET /admin/resources/1" do
      params_from(:get, "/admin/resources/1").should == {:controller => "admin/resources", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'edit', id => '1' } from GET /admin/resources/1;edit" do
      params_from(:get, "/admin/resources/1/edit").should == {:controller => "admin/resources", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'update', id => '1' } from PUT /admin/resources/1" do
      params_from(:put, "/admin/resources/1").should == {:controller => "admin/resources", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'destroy', id => '1' } from DELETE /admin/resources/1" do
      params_from(:delete, "/admin/resources/1").should == {:controller => "admin/resources", :action => "destroy", :id => "1"}
    end
  end
  
  
  ## These are the routes for the case where the resources are inside the theme i.e. /themes/1/resource
  
  
  describe "route generation" do

    it "should map { :controller => 'admin/resources', :action => 'index' } to /admin/themes/1/resources" do
      route_for(:controller => "admin/resources", :action => "index", :theme_id => '1').should == "/admin/themes/1/resources"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'new' } to /admin/themes/1/resources/new" do
      route_for(:controller => "admin/resources", :action => "new", :theme_id => '1').should == "/admin/themes/1/resources/new"
    end

    it "should map { :controller => 'admin/resources', :action => 'create' } to /admin/themes/1/resources" do
      route_for(:controller => "admin/resources", :action => "create", :theme_id => '1').should == "/admin/themes/1/resources"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'show', :id => 1 } to /admin/themes/1/resources/1" do
      route_for(:controller => "admin/resources", :action => "show", :id => 1, :theme_id => '1').should == "/admin/themes/1/resources/1"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'edit', :id => 1 } to /admin/themes/1/resources/1/edit" do
      route_for(:controller => "admin/resources", :action => "edit", :id => 1, :theme_id => '1').should == "/admin/themes/1/resources/1/edit"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'update', :id => 1} to /admin/themes/1/resources/1" do
      route_for(:controller => "admin/resources", :action => "update", :id => 1, :theme_id => '1').should == "/admin/themes/1/resources/1"
    end
  
    it "should map { :controller => 'admin/resources', :action => 'destroy', :id => 1} to /admin/themes/1/resources/1" do
      route_for(:controller => "admin/resources", :action => "destroy", :id => 1, :theme_id => '1').should == "/admin/themes/1/resources/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/resources', action => 'index' } from GET /admin/themes/1/resources" do
      params_from(:get, "/admin/themes/1/resources").should == {:controller => "admin/resources", :action => "index", :theme_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'new' } from GET /admin/themes/1/resources/new" do
      params_from(:get, "/admin/themes/1/resources/new").should == {:controller => "admin/resources", :action => "new", :theme_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'create' } from POST /admin/themes/1/resources" do
      params_from(:post, "/admin/themes/1/resources").should == {:controller => "admin/resources", :action => "create", :theme_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'show', id => '1' } from GET /admin/themes/1/resources/1" do
      params_from(:get, "/admin/themes/1/resources/1").should == {:controller => "admin/resources", :action => "show", :id => "1", :theme_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'edit', id => '1' } from GET /admin/themes/1/resources/1;edit" do
      params_from(:get, "/admin/themes/1/resources/1/edit").should == {:controller => "admin/resources", :action => "edit", :id => "1", :theme_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'update', id => '1' } from PUT /admin/themes/1/resources/1" do
      params_from(:put, "/admin/themes/1/resources/1").should == {:controller => "admin/resources", :action => "update", :id => "1", :theme_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resources', action => 'destroy', id => '1' } from DELETE /admin/themes/1/resources/1" do
      params_from(:delete, "/admin/themes/1/resources/1").should == {:controller => "admin/resources", :action => "destroy", :id => "1", :theme_id => '1'}
    end
  end
  
end
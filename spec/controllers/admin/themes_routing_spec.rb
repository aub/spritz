require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ThemesController do
  describe "route generation" do

    it "should map { :controller => 'admin/themes', :action => 'index' } to /admin/themes" do
      route_for(:controller => "admin/themes", :action => "index").should == "/admin/themes"
    end
  
    it "should map { :controller => 'admin/themes', :action => 'new' } to /admin/themes/new" do
      route_for(:controller => "admin/themes", :action => "new").should == "/admin/themes/new"
    end
    
    it "should map { :controller => 'admin/themes', :action => 'create' } to /admin/themes" do
      route_for(:controller => "admin/themes", :action => "create").should == "/admin/themes"
    end
  
    it "should map { :controller => 'admin/themes', :action => 'show', :id => 1 } to /admin/themes/1" do
      route_for(:controller => "admin/themes", :action => "show", :id => 1).should == "/admin/themes/1"
    end
  
    it "should map { :controller => 'admin/themes', :action => 'edit', :id => 1 } to /admin/themes/1/edit" do
      route_for(:controller => "admin/themes", :action => "edit", :id => 1).should == "/admin/themes/1/edit"
    end
  
    it "should map { :controller => 'admin/themes', :action => 'update', :id => 1} to /admin/themes/1" do
      route_for(:controller => "admin/themes", :action => "update", :id => 1).should == "/admin/themes/1"
    end
  
    it "should map { :controller => 'admin/themes', :action => 'destroy', :id => 1} to /admin/themes/1" do
      route_for(:controller => "admin/themes", :action => "destroy", :id => 1).should == "/admin/themes/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/themes', action => 'index' } from GET /admin/themes" do
      params_from(:get, "/admin/themes").should == {:controller => "admin/themes", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/themes', action => 'new' } from GET /admin/themes/new" do
      params_from(:get, "/admin/themes/new").should == {:controller => "admin/themes", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/themes', action => 'create' } from POST /admin/themes" do
      params_from(:post, "/admin/themes").should == {:controller => "admin/themes", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/themes', action => 'show', id => '1' } from GET /admin/themes/1" do
      params_from(:get, "/admin/themes/1").should == {:controller => "admin/themes", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/themes', action => 'edit', id => '1' } from GET /admin/themes/1;edit" do
      params_from(:get, "/admin/themes/1/edit").should == {:controller => "admin/themes", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/themes', action => 'update', id => '1' } from PUT /admin/themes/1" do
      params_from(:put, "/admin/themes/1").should == {:controller => "admin/themes", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/themes', action => 'destroy', id => '1' } from DELETE /admin/themes/1" do
      params_from(:delete, "/admin/themes/1").should == {:controller => "admin/themes", :action => "destroy", :id => "1"}
    end
  end
  
  describe "custom routes" do
    it "should map { :controller => 'admin/themes', :action => 'activate', :id => 1} to /admin/themes/1/activate" do
      route_for(:controller => "admin/themes", :action => "activate", :id => 1).should == "/admin/themes/1/activate"
    end
    
    it "should map { :controller => 'admin/themes', :action => 'preview', :id => 1} to /admin/themes/1/preview" do
      route_for(:controller => "admin/themes", :action => "preview", :id => 1).should == "/admin/themes/1/preview"
    end
    
    
    it "should generate params { :controller => 'admin/themes', action => 'activate', id => '1' } from PUT /admin/themes/1/activate" do
      params_from(:put, "/admin/themes/1/activate").should == {:controller => "admin/themes", :action => "activate", :id => "1"}
    end
    
    it "should generate params { :controller => 'admin/themes', action => 'preview', id => '1' } from PUT /admin/themes/1/preview" do
      params_from(:get, "/admin/themes/1/preview").should == {:controller => "admin/themes", :action => "preview", :id => "1"}
    end
  end
end
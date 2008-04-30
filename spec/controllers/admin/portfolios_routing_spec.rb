require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PortfoliosController do
  describe "route generation" do

    it "should map { :controller => 'admin/portfolios', :action => 'index' } to /admin/portfolios" do
      route_for(:controller => "admin/portfolios", :action => "index").should == "/admin/portfolios"
    end
  
    it "should map { :controller => 'admin/portfolios', :action => 'new' } to /admin/portfolios/new" do
      route_for(:controller => "admin/portfolios", :action => "new").should == "/admin/portfolios/new"
    end

    it "should map { :controller => 'admin/portfolios', :action => 'create' } to /admin/portfolios" do
      route_for(:controller => "admin/portfolios", :action => "create").should == "/admin/portfolios"
    end
  
    it "should map { :controller => 'admin/portfolios', :action => 'show', :id => 1 } to /admin/portfolios/1" do
      route_for(:controller => "admin/portfolios", :action => "show", :id => 1).should == "/admin/portfolios/1"
    end
  
    it "should map { :controller => 'admin/portfolios', :action => 'edit', :id => 1 } to /admin/portfolios/1/edit" do
      route_for(:controller => "admin/portfolios", :action => "edit", :id => 1).should == "/admin/portfolios/1/edit"
    end
  
    it "should map { :controller => 'admin/portfolios', :action => 'update', :id => 1} to /admin/portfolios/1" do
      route_for(:controller => "admin/portfolios", :action => "update", :id => 1).should == "/admin/portfolios/1"
    end
  
    it "should map { :controller => 'admin/portfolios', :action => 'destroy', :id => 1} to /admin/portfolios/1" do
      route_for(:controller => "admin/portfolios", :action => "destroy", :id => 1).should == "/admin/portfolios/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/portfolios', action => 'index' } from GET /admin/portfolios" do
      params_from(:get, "/admin/portfolios").should == {:controller => "admin/portfolios", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/portfolios', action => 'new' } from GET /admin/portfolios/new" do
      params_from(:get, "/admin/portfolios/new").should == {:controller => "admin/portfolios", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/portfolios', action => 'create' } from POST /admin/portfolios" do
      params_from(:post, "/admin/portfolios").should == {:controller => "admin/portfolios", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/portfolios', action => 'show', id => '1' } from GET /admin/portfolios/1" do
      params_from(:get, "/admin/portfolios/1").should == {:controller => "admin/portfolios", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/portfolios', action => 'edit', id => '1' } from GET /admin/portfolios/1;edit" do
      params_from(:get, "/admin/portfolios/1/edit").should == {:controller => "admin/portfolios", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/portfolios', action => 'update', id => '1' } from PUT /admin/portfolios/1" do
      params_from(:put, "/admin/portfolios/1").should == {:controller => "admin/portfolios", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/portfolios', action => 'destroy', id => '1' } from DELETE /admin/portfolios/1" do
      params_from(:delete, "/admin/portfolios/1").should == {:controller => "admin/portfolios", :action => "destroy", :id => "1"}
    end
  end
  
  describe "custom routes" do
    it "should map { :controller => 'admin/portfolios', :action => 'add_child', :id => 1} to /admin/portfolios/1/add_child" do
      route_for(:controller => "admin/portfolios", :action => "add_child", :id => 1).should == "/admin/portfolios/1/add_child"
    end

    it "should generate params { :controller => 'admin/portfolios', action => 'add_child', id => '1' } from GET /admin/portfolios/1/add_child" do
      params_from(:get, "/admin/portfolios/1/add_child").should == {:controller => "admin/portfolios", :action => "add_child", :id => "1"}
    end
  end
end
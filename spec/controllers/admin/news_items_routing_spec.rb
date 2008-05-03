require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::NewsItemsController do
  describe "route generation" do

    it "should map { :controller => 'admin/news_items', :action => 'index' } to /admin/news_items" do
      route_for(:controller => "admin/news_items", :action => "index").should == "/admin/news_items"
    end
  
    it "should map { :controller => 'admin/news_items', :action => 'new' } to /admin/news_items/new" do
      route_for(:controller => "admin/news_items", :action => "new").should == "/admin/news_items/new"
    end
  
    it "should map { :controller => 'admin/news_items', :action => 'show', :id => 1 } to /admin/news_items/1" do
      route_for(:controller => "admin/news_items", :action => "show", :id => 1).should == "/admin/news_items/1"
    end
  
    it "should map { :controller => 'admin/news_items', :action => 'edit', :id => 1 } to /admin/news_items/1/edit" do
      route_for(:controller => "admin/news_items", :action => "edit", :id => 1).should == "/admin/news_items/1/edit"
    end
  
    it "should map { :controller => 'admin/news_items', :action => 'update', :id => 1} to /admin/news_items/1" do
      route_for(:controller => "admin/news_items", :action => "update", :id => 1).should == "/admin/news_items/1"
    end
  
    it "should map { :controller => 'admin/news_items', :action => 'destroy', :id => 1} to /admin/news_items/1" do
      route_for(:controller => "admin/news_items", :action => "destroy", :id => 1).should == "/admin/news_items/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/news_items', action => 'index' } from GET /admin/news_items" do
      params_from(:get, "/admin/news_items").should == {:controller => "admin/news_items", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/news_items', action => 'new' } from GET /admin/news_items/new" do
      params_from(:get, "/admin/news_items/new").should == {:controller => "admin/news_items", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/news_items', action => 'create' } from POST /admin/news_items" do
      params_from(:post, "/admin/news_items").should == {:controller => "admin/news_items", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/news_items', action => 'show', id => '1' } from GET /admin/news_items/1" do
      params_from(:get, "/admin/news_items/1").should == {:controller => "admin/news_items", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/news_items', action => 'edit', id => '1' } from GET /admin/news_items/1;edit" do
      params_from(:get, "/admin/news_items/1/edit").should == {:controller => "admin/news_items", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/news_items', action => 'update', id => '1' } from PUT /admin/news_items/1" do
      params_from(:put, "/admin/news_items/1").should == {:controller => "admin/news_items", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/news_items', action => 'destroy', id => '1' } from DELETE /admin/news_items/1" do
      params_from(:delete, "/admin/news_items/1").should == {:controller => "admin/news_items", :action => "destroy", :id => "1"}
    end
  end
end
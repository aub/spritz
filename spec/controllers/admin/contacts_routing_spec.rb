require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ContactsController do
  describe "route generation" do

    it "should map { :controller => 'admin/contacts', :action => 'index' } to /admin/contacts" do
      route_for(:controller => "admin/contacts", :action => "index").should == "/admin/contacts"
    end
  
    it "should map { :controller => 'admin/contacts', :action => 'new' } to /admin/contacts/new" do
      route_for(:controller => "admin/contacts", :action => "new").should == "/admin/contacts/new"
    end
  
    it "should map { :controller => 'admin/contacts', :action => 'show', :id => 1 } to /admin/contacts/1" do
      route_for(:controller => "admin/contacts", :action => "show", :id => 1).should == "/admin/contacts/1"
    end
  
    it "should map { :controller => 'admin/contacts', :action => 'edit', :id => 1 } to /admin/contacts/1/edit" do
      route_for(:controller => "admin/contacts", :action => "edit", :id => 1).should == "/admin/contacts/1/edit"
    end
  
    it "should map { :controller => 'admin/contacts', :action => 'update', :id => 1} to /admin/contacts/1" do
      route_for(:controller => "admin/contacts", :action => "update", :id => 1).should == "/admin/contacts/1"
    end
  
    it "should map { :controller => 'admin/contacts', :action => 'destroy', :id => 1} to /admin/contacts/1" do
      route_for(:controller => "admin/contacts", :action => "destroy", :id => 1).should == "/admin/contacts/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/contacts', action => 'index' } from GET /admin/contacts" do
      params_from(:get, "/admin/contacts").should == {:controller => "admin/contacts", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/contacts', action => 'new' } from GET /admin/contacts/new" do
      params_from(:get, "/admin/contacts/new").should == {:controller => "admin/contacts", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/contacts', action => 'create' } from POST /admin/contacts" do
      params_from(:post, "/admin/contacts").should == {:controller => "admin/contacts", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/contacts', action => 'show', id => '1' } from GET /admin/contacts/1" do
      params_from(:get, "/admin/contacts/1").should == {:controller => "admin/contacts", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/contacts', action => 'edit', id => '1' } from GET /admin/contacts/1;edit" do
      params_from(:get, "/admin/contacts/1/edit").should == {:controller => "admin/contacts", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/contacts', action => 'update', id => '1' } from PUT /admin/contacts/1" do
      params_from(:put, "/admin/contacts/1").should == {:controller => "admin/contacts", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/contacts', action => 'destroy', id => '1' } from DELETE /admin/contacts/1" do
      params_from(:delete, "/admin/contacts/1").should == {:controller => "admin/contacts", :action => "destroy", :id => "1"}
    end
  end
end
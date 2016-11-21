require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::MembershipsController do
  describe "route generation" do

    it "should map { :controller => 'admin/memberships', :action => 'index', :user_id => '1' } to /admin/users/1/memberships" do
      route_for(:controller => "admin/memberships", :action => "index", :user_id => '1').should == "/admin/users/1/memberships"
    end
  
    it "should map { :controller => 'admin/memberships', :action => 'new', :user_id => '1' } to /admin/users/1/memberships/new" do
      route_for(:controller => "admin/memberships", :action => "new", :user_id => '1').should == "/admin/users/1/memberships/new"
    end

    it "should map { :controller => 'admin/memberships', :action => 'create', :user_id => '1' } to /admin/users/1/memberships" do
      route_for(:controller => "admin/memberships", :action => "create", :user_id => '1').should == "/admin/users/1/memberships"
    end
  
    it "should map { :controller => 'admin/memberships', :action => 'show', :id => 1, :user_id => '1' } to /admin/users/1/memberships/1" do
      route_for(:controller => "admin/memberships", :action => "show", :id => 1, :user_id => '1').should == "/admin/users/1/memberships/1"
    end
  
    it "should map { :controller => 'admin/memberships', :action => 'edit', :id => 1, :user_id => '1' } to /admin/users/1/memberships/1/edit" do
      route_for(:controller => "admin/memberships", :action => "edit", :id => 1, :user_id => '1').should == "/admin/users/1/memberships/1/edit"
    end
  
    it "should map { :controller => 'admin/memberships', :action => 'update', :id => 1, :user_id => '1'} to /admin/users/1/memberships/1" do
      route_for(:controller => "admin/memberships", :action => "update", :id => 1, :user_id => '1').should == "/admin/users/1/memberships/1"
    end
  
    it "should map { :controller => 'admin/memberships', :action => 'destroy', :id => 1, :user_id => '1'} to /admin/users/1/memberships/1" do
      route_for(:controller => "admin/memberships", :action => "destroy", :id => 1, :user_id => '1').should == "/admin/users/1/memberships/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/memberships', action => 'index', :user_id => '1' } from GET /admin/users/1/memberships" do
      params_from(:get, "/admin/users/1/memberships").should == {:controller => "admin/memberships", :action => "index", :user_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/memberships', action => 'new', :user_id => '1' } from GET /admin/users/1/memberships/new" do
      params_from(:get, "/admin/users/1/memberships/new").should == {:controller => "admin/memberships", :action => "new", :user_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/memberships', action => 'create', :user_id => '1' } from POST /admin/users/1/memberships" do
      params_from(:post, "/admin/users/1/memberships").should == {:controller => "admin/memberships", :action => "create", :user_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/memberships', action => 'show', id => '1', :user_id => '1' } from GET /admin/users/1/memberships/1" do
      params_from(:get, "/admin/users/1/memberships/1").should == {:controller => "admin/memberships", :action => "show", :id => "1", :user_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/memberships', action => 'edit', id => '1', :user_id => '1' } from GET /admin/users/1/memberships/1;edit" do
      params_from(:get, "/admin/users/1/memberships/1/edit").should == {:controller => "admin/memberships", :action => "edit", :id => "1", :user_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/memberships', action => 'update', id => '1', :user_id => '1' } from PUT /admin/users/1/memberships/1" do
      params_from(:put, "/admin/users/1/memberships/1").should == {:controller => "admin/memberships", :action => "update", :id => "1", :user_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/memberships', action => 'destroy', id => '1', :user_id => '1' } from DELETE /admin/users/1/memberships/1" do
      params_from(:delete, "/admin/users/1/memberships/1").should == {:controller => "admin/memberships", :action => "destroy", :id => "1", :user_id => '1'}
    end
  end
end
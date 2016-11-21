require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersController do
  describe "route generation" do

    it "should map { :controller => 'admin/users', :action => 'index' } to /admin/users" do
      route_for(:controller => "admin/users", :action => "index").should == "/admin/users"
    end
  
    it "should map { :controller => 'admin/users', :action => 'new' } to /admin/users/new" do
      route_for(:controller => "admin/users", :action => "new").should == "/admin/users/new"
    end

    it "should map { :controller => 'admin/users', :action => 'create' } to /admin/users" do
      route_for(:controller => "admin/users", :action => "create").should == "/admin/users"
    end
  
    it "should map { :controller => 'admin/users', :action => 'show', :id => 1 } to /admin/users/1" do
      route_for(:controller => "admin/users", :action => "show", :id => 1).should == "/admin/users/1"
    end
  
    it "should map { :controller => 'admin/users', :action => 'edit', :id => 1 } to /admin/users/1/edit" do
      route_for(:controller => "admin/users", :action => "edit", :id => 1).should == "/admin/users/1/edit"
    end
  
    it "should map { :controller => 'admin/users', :action => 'update', :id => 1} to /admin/users/1" do
      route_for(:controller => "admin/users", :action => "update", :id => 1).should == "/admin/users/1"
    end
  
    it "should map { :controller => 'admin/users', :action => 'destroy', :id => 1} to /admin/users/1" do
      route_for(:controller => "admin/users", :action => "destroy", :id => 1).should == "/admin/users/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/users', action => 'index' } from GET /admin/users" do
      params_from(:get, "/admin/users").should == {:controller => "admin/users", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/users', action => 'new' } from GET /admin/users/new" do
      params_from(:get, "/admin/users/new").should == {:controller => "admin/users", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/users', action => 'create' } from POST /admin/users" do
      params_from(:post, "/admin/users").should == {:controller => "admin/users", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/users', action => 'show', id => '1' } from GET /admin/users/1" do
      params_from(:get, "/admin/users/1").should == {:controller => "admin/users", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/users', action => 'edit', id => '1' } from GET /admin/users/1;edit" do
      params_from(:get, "/admin/users/1/edit").should == {:controller => "admin/users", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/users', action => 'update', id => '1' } from PUT /admin/users/1" do
      params_from(:put, "/admin/users/1").should == {:controller => "admin/users", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/users', action => 'destroy', id => '1' } from DELETE /admin/users/1" do
      params_from(:delete, "/admin/users/1").should == {:controller => "admin/users", :action => "destroy", :id => "1"}
    end
  end
  
  describe "custom routes" do

    it "should map { :controller => 'admin/users', :action => 'suspend', :id => 1} to /admin/users/1/suspend" do
      route_for(:controller => "admin/users", :action => "suspend", :id => 1).should == "/admin/users/1/suspend"
    end
    
    it "should map { :controller => 'admin/users', :action => 'unsuspend', :id => 1} to /admin/users/1/unsuspend" do
      route_for(:controller => "admin/users", :action => "unsuspend", :id => 1).should == "/admin/users/1/unsuspend"
    end
    
    it "should map { :controller => 'admin/users', :action => 'purge', :id => 1} to /admin/users/1/purge" do
      route_for(:controller => "admin/users", :action => "purge", :id => 1).should == "/admin/users/1/purge"
    end

    it "should map { :controller => 'admin/users', :action => 'forgot_password'} to /admin/users/forgot_password" do
      route_for(:controller => "admin/users", :action => "forgot_password").should == "/admin/users/forgot_password"
    end

    it "should map { :controller => 'admin/users', :action => 'reset_password'} to /admin/users/reset_password" do
      route_for(:controller => "admin/users", :action => "reset_password").should == "/admin/users/reset_password"
    end

    it "should map { :controller => 'admin/users', :action => 'login_from_token', :id => '1'} to /admin/users/1/login_from_token" do
      route_for(:controller => "admin/users", :action => "login_from_token", :id => '1').should == "/admin/users/1/login_from_token"
    end


    it "should generate params { :controller => 'admin/users', action => 'suspend', id => '1' } from PUT /admin/users/1/suspend" do
      params_from(:put, "/admin/users/1/suspend").should == {:controller => "admin/users", :action => "suspend", :id => "1"}
    end 
    
    it "should generate params { :controller => 'admin/users', action => 'unsuspend', id => '1' } from PUT /admin/users/1/unsuspend" do
      params_from(:put, "/admin/users/1/unsuspend").should == {:controller => "admin/users", :action => "unsuspend", :id => "1"}
    end 
    
    it "should generate params { :controller => 'admin/users', action => 'purge', id => '1' } from DELETE /admin/users/1/purge" do
      params_from(:delete, "/admin/users/1/purge").should == {:controller => "admin/users", :action => "purge", :id => "1"}
    end

    it "should generate params { :controller => 'admin/users', action => 'forgot_password' } from PUT /admin/users/forgot_password" do
      params_from(:get, "/admin/users/forgot_password").should == {:controller => "admin/users", :action => "forgot_password"}
    end     
    
    it "should generate params { :controller => 'admin/users', action => 'reset_password' } from PUT /admin/users/reset_password" do
      params_from(:put, "/admin/users/reset_password").should == {:controller => "admin/users", :action => "reset_password"}
    end
    
    it "should generate params { :controller => 'admin/users', action => 'login_from_token', :id => '1' } from GET /admin/users/1/login_from_token" do
      params_from(:get, "/admin/users/1/login_from_token").should == {:controller => "admin/users", :action => "login_from_token", :id => '1'}
    end     
  end
  
  describe "activation routes" do
    it "should map { :controller => 'admin/users', :action => 'activate', :activation_code => 'code'} to /activate/code" do
      route_for(:controller => "admin/users", :action => "activate", :activation_code => 'code').should == "/activate/code"
    end
    
    it "should generate params { :controller => 'admin/users', action => 'activate', activation_code => 'code' } from GET /activate/code" do
      params_from(:get, "/activate/code").should == {:controller => "admin/users", :action => "activate", :activation_code => "code"}
    end
  end
end
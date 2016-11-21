require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SessionController do
  describe "route generation" do

    it "should map { :controller => 'admin/session', :action => 'show' } to /admin/session" do
      route_for(:controller => "admin/session", :action => "show").should == "/admin/session"
    end
  
    it "should map { :controller => 'admin/session', :action => 'new' } to /admin/session/new" do
      route_for(:controller => "admin/session", :action => "new").should == "/admin/session/new"
    end
    
    it "should map { :controller => 'admin/session', :action => 'create' } to /admin/session" do
      route_for(:controller => "admin/session", :action => "create").should == "/admin/session"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/session', action => 'show' } from GET /admin/session" do
      params_from(:get, "/admin/session").should == {:controller => "admin/session", :action => "show"}
    end
  
    it "should generate params { :controller => 'admin/session', action => 'new' } from GET /admin/session/new" do
      params_from(:get, "/admin/session/new").should == {:controller => "admin/session", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/session', action => 'create' } from POST /admin/session" do
      params_from(:post, "/admin/session").should == {:controller => "admin/session", :action => "create"}
    end
  end
end
require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::SessionsController do
  describe "route generation" do

    it "should map { :controller => 'admin/sessions', :action => 'show' } to /admin/session" do
      route_for(:controller => "admin/sessions", :action => "show").should == "/admin/session"
    end
  
    it "should map { :controller => 'admin/sessions', :action => 'new' } to /admin/session/new" do
      route_for(:controller => "admin/sessions", :action => "new").should == "/admin/session/new"
    end  
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/sessions', action => 'show' } from GET /admin/session" do
      params_from(:get, "/admin/session").should == {:controller => "admin/sessions", :action => "show"}
    end
  
    it "should generate params { :controller => 'admin/sessions', action => 'new' } from GET /admin/session/new" do
      params_from(:get, "/admin/session/new").should == {:controller => "admin/sessions", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/sessions', action => 'create' } from POST /admin/session" do
      params_from(:post, "/admin/session").should == {:controller => "admin/sessions", :action => "create"}
    end
  end
end
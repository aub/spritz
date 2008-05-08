require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HomeController do
  describe "route generation" do

    it "should map { :controller => 'admin/home', :action => 'edit' } to /admin/home/edit" do
      route_for(:controller => "admin/home", :action => "edit").should == "/admin/home/edit"
    end
  
    it "should map { :controller => 'admin/home', :action => 'update' } to /admin/home" do
      route_for(:controller => "admin/home", :action => "update").should == "/admin/home"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/home', action => 'edit' } from GET /admin/home/edit" do
      params_from(:get, "/admin/home/edit").should == {:controller => "admin/home", :action => "edit"}
    end
  
    it "should generate params { :controller => 'admin/home', action => 'update' } from PUT /admin/home" do
      params_from(:put, "/admin/home").should == {:controller => "admin/home", :action => "update"}
    end
  end
end
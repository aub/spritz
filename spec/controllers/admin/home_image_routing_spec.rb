require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HomeImageController do
  describe "route generation" do

    it "should map { :controller => 'admin/home_image', :action => 'edit' } to /admin/home/home_image/edit" do
      route_for(:controller => "admin/home_image", :action => "edit").should == "/admin/home/home_image/edit"
    end
  
    it "should map { :controller => 'admin/home_image', :action => 'update' } to /admin/home/home_image" do
      route_for(:controller => "admin/home_image", :action => "update").should == "/admin/home/home_image"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/home_image', action => 'edit' } from GET /admin/home/home_image/edit" do
      params_from(:get, "/admin/home/home_image/edit").should == {:controller => "admin/home_image", :action => "edit"}
    end
  
    it "should generate params { :controller => 'admin/home_image', action => 'update' } from PUT /admin/home/home_image" do
      params_from(:put, "/admin/home/home_image").should == {:controller => "admin/home_image", :action => "update"}
    end
  end
end
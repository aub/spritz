require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HelpController do
  describe "route generation" do

    it "should map { :controller => 'admin/help', :action => 'show', :page => 'textile' } to /admin/help/textile" do
      route_for(:controller => "admin/help", :action => "show", :page => 'textile').should == "/admin/help/textile"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/help', action => 'show', :page => 'textile' } from GET /admin/help/textile" do
      params_from(:get, "/admin/help/textile").should == {:controller => "admin/help", :action => "show", :page => 'textile' }
    end
  end
end
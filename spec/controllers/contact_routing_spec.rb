require File.dirname(__FILE__) + '/../spec_helper'

describe ContactController do
  describe "route generation" do

    it "should map { :controller => 'contact', :action => 'new' } to /contact/new" do
      route_for(:controller => "contact", :action => "new").should == "/contact/new"
    end
    
    it "should map { :controller => 'contact', :action => 'create' } to /contact" do
      route_for(:controller => "contact", :action => "create").should == "/contact"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'contact', action => 'new' } from GET /contact/new" do
      params_from(:get, "/contact/new").should == {:controller => "contact", :action => "new"}
    end
    
    it "should generate params { :controller => 'contact', action => 'contact' } from POST /contact" do
      params_from(:post, "/contact").should == {:controller => "contact", :action => "create"}
    end
  end
end
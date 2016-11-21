require File.dirname(__FILE__) + '/../spec_helper'

describe ThemeController do
  describe "route generation" do

    it "should map { :controller => 'theme', :action => 'stylesheets', :filename => 'f', :ext => 'css' } to /theme/stylesheets/f.css" do
      route_for(:controller => "theme", :action => "stylesheets", :filename => 'f', :ext => 'css').should == "/theme/stylesheets/f.css"
    end
    
    it "should map { :controller => 'theme', :action => 'images', :filename => 'f', :ext => 'png' } to /theme/images/f.png" do
      route_for(:controller => "theme", :action => "images", :filename => 'f', :ext => 'png').should == "/theme/images/f.png"
    end
    
    it "should map { :controller => 'theme', :action => 'javascripts', :filename => 'f', :ext => 'js' } to /theme/javascripts/f.js" do
      route_for(:controller => "theme", :action => "javascripts", :filename => 'f', :ext => 'js').should == "/theme/javascripts/f.js"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'theme', action => 'stylesheets', :filename => 'f', :ext => 'css' } from GET /theme/stylesheets/f.css" do
      params_from(:get, "/theme/stylesheets/f.css").should == {:controller => "theme", :action => "stylesheets", :filename => 'f', :ext => 'css'}
    end
    
    it "should generate params { :controller => 'theme', action => 'images', :filename => 'f', :ext => 'png' } from GET /theme/images/f.png" do
      params_from(:get, "/theme/images/f.png").should == {:controller => "theme", :action => "images", :filename => 'f', :ext => 'png'}
    end
    
    it "should generate params { :controller => 'theme', action => 'javascripts', :filename => 'f', :ext => 'js' } from GET /theme/javascripts/f.js" do
      params_from(:get, "/theme/javascripts/f.js").should == {:controller => "theme", :action => "javascripts", :filename => 'f', :ext => 'js'}
    end
  end
end
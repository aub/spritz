require File.dirname(__FILE__) + '/../spec_helper'

describe Admin::ThemeController do
  describe "route generation" do

    it "should map { :controller => 'theme', :action => 'stylesheets', :filename => 'f', :ext => 'css' } to /stylesheets/theme/f.css" do
      route_for(:controller => "theme", :action => "stylesheets", :filename => 'f', :ext => 'css').should == "/stylesheets/theme/f.css"
    end
    
    it "should map { :controller => 'theme', :action => 'images', :filename => 'f', :ext => 'png' } to /images/theme/f.png" do
      route_for(:controller => "theme", :action => "images", :filename => 'f', :ext => 'png').should == "/images/theme/f.png"
    end
    
    it "should map { :controller => 'theme', :action => 'javascripts', :filename => 'f', :ext => 'js' } to /javascripts/theme/f.js" do
      route_for(:controller => "theme", :action => "javascripts", :filename => 'f', :ext => 'js').should == "/javascripts/theme/f.js"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'theme', action => 'stylesheets', :filename => 'f', :ext => 'css' } from GET /stylesheets/theme/f.css" do
      params_from(:get, "/stylesheets/theme/f.css").should == {:controller => "theme", :action => "stylesheets", :filename => 'f', :ext => 'css'}
    end
    
    it "should generate params { :controller => 'theme', action => 'images', :filename => 'f', :ext => 'png' } from GET /images/theme/f.png" do
      params_from(:get, "/images/theme/f.png").should == {:controller => "theme", :action => "images", :filename => 'f', :ext => 'png'}
    end
    
    it "should generate params { :controller => 'theme', action => 'javascripts', :filename => 'f', :ext => 'js' } from GET /javascripts/theme/f.js" do
      params_from(:get, "/javascripts/theme/f.js").should == {:controller => "theme", :action => "javascripts", :filename => 'f', :ext => 'js'}
    end
  end
end
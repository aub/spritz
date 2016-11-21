require File.dirname(__FILE__) + '/../spec_helper'

describe ItemsController do
  describe "route generation" do

    it "should map { :controller => 'items', :action => 'show', :id => '1', :portfolio_id => '1' } to /portfolios/1/items/1" do
      route_for(:controller => "items", :action => "show", :id => '1', :portfolio_id => '1').should == "/portfolios/1/items/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'items', action => 'show', :id => '1', :portfolio_id => '1' } from GET /portfolios/1/items/1" do
      params_from(:get, "/portfolios/1/items/1").should == {:controller => "items", :action => "show", :id => '1', :portfolio_id => '1'}
    end
  end
end
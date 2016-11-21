require File.dirname(__FILE__) + '/../spec_helper'

describe PortfoliosController do
  describe "route generation" do

    it "should map { :controller => 'portfolios', :action => 'show', :id => '1' } to /portfolios/1" do
      route_for(:controller => "portfolios", :action => "show", :id => '1').should == "/portfolios/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'portfolios', action => 'show', :id => '1' } from GET /portfolios/1" do
      params_from(:get, "/portfolios/1").should == {:controller => "portfolios", :action => "show", :id => '1'}
    end
  end
end
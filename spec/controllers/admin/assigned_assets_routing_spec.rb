require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::LinksController do
  describe "route generation" do

    it "should map { :controller => 'admin/assigned_assets', :action => 'create', :portfolio_id => '1'} to /portfolios/1/assigned_assets" do
      route_for(:controller => "admin/assigned_assets", :action => "create", :portfolio_id => '1').should == "/admin/portfolios/1/assigned_assets"
    end    
  
    it "should map { :controller => 'admin/assigned_assets', :action => 'destroy', :id => 1, :portfolio_id => '1'} to /portfolios/1/assigned_assets/1" do
      route_for(:controller => "admin/assigned_assets", :action => "destroy", :id => 1, :portfolio_id => '1').should == "/admin/portfolios/1/assigned_assets/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/assigned_assets', action => 'create' } from POST /portfolios/1/assigned_assets" do
      params_from(:post, "/admin/portfolios/1/assigned_assets").should == {:controller => "admin/assigned_assets", :action => "create", :portfolio_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/assigned_assets', action => 'destroy', id => '1' } from DELETE /portfolios/1/assigned_assets/1" do
      params_from(:delete, "/admin/portfolios/1/assigned_assets/1").should == {:controller => "admin/assigned_assets", :action => "destroy", :id => "1", :portfolio_id => '1'}
    end
  end
end
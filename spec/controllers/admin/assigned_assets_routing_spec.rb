require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AssignedAssetsController do
  describe "route generation" do

    it "should map { :controller => 'admin/assigned_assets', :action => 'new', :portfolio_id => '1'} to /portfolios/1/assigned_assets/new" do
      route_for(:controller => "admin/assigned_assets", :action => "new", :portfolio_id => '1').should == "/admin/portfolios/1/assigned_assets/new"
    end    

    it "should map { :controller => 'admin/assigned_assets', :action => 'create', :portfolio_id => '1'} to /portfolios/1/assigned_assets" do
      route_for(:controller => "admin/assigned_assets", :action => "create", :portfolio_id => '1').should == "/admin/portfolios/1/assigned_assets"
    end    
  
    it "should map { :controller => 'admin/assigned_assets', :action => 'destroy', :id => 1, :portfolio_id => '1'} to /portfolios/1/assigned_assets/1" do
      route_for(:controller => "admin/assigned_assets", :action => "destroy", :id => 1, :portfolio_id => '1').should == "/admin/portfolios/1/assigned_assets/1"
    end
    
    it "should map { :controller => 'admin/assigned_assets', :action => 'select', :portfolio_id => '1'} to /portfolios/1/assigned_assets/select" do
      route_for(:controller => "admin/assigned_assets", :action => "select", :portfolio_id => '1').should == "/admin/portfolios/1/assigned_assets/select"
    end

    it "should map { :controller => 'admin/assigned_assets', :action => 'deselect', :portfolio_id => '1'} to /portfolios/1/assigned_assets/deselect" do
      route_for(:controller => "admin/assigned_assets", :action => "deselect", :portfolio_id => '1').should == "/admin/portfolios/1/assigned_assets/deselect"
    end
    
    it "should map { :controller => 'admin/assigned_assets', :action => 'clear', :portfolio_id => '1'} to /portfolios/1/assigned_assets/clear" do
      route_for(:controller => "admin/assigned_assets", :action => "clear", :portfolio_id => '1').should == "/admin/portfolios/1/assigned_assets/clear"
    end
    
    it "should map { :controller => 'admin/assigned_assets', :action => 'reorder', :portfolio_id => 1} to /admin/portfolios/1/assigned_assets/reorder" do
      route_for(:controller => "admin/assigned_assets", :action => "reorder", :portfolio_id => 1).should == "/admin/portfolios/1/assigned_assets/reorder"
    end
    
    it "should map { :controller => 'admin/assigned_assets', :action => 'update_order', :portfolio_id => 1} to /admin/portfolios/1/assigned_assets/update_order" do
      route_for(:controller => "admin/assigned_assets", :action => "update_order", :portfolio_id => 1).should == "/admin/portfolios/1/assigned_assets/update_order"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/assigned_assets', action => 'new', :portfolio_id => '1' } from POST /portfolios/1/assigned_assets/new" do
      params_from(:get, "/admin/portfolios/1/assigned_assets/new").should == {:controller => "admin/assigned_assets", :action => "new", :portfolio_id => '1'}
    end

    it "should generate params { :controller => 'admin/assigned_assets', action => 'create', :portfolio_id => '1' } from POST /portfolios/1/assigned_assets" do
      params_from(:post, "/admin/portfolios/1/assigned_assets").should == {:controller => "admin/assigned_assets", :action => "create", :portfolio_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/assigned_assets', action => 'destroy', id => '1', :portfolio_id => '1' } from DELETE /portfolios/1/assigned_assets/1" do
      params_from(:delete, "/admin/portfolios/1/assigned_assets/1").should == {:controller => "admin/assigned_assets", :action => "destroy", :id => "1", :portfolio_id => '1'}
    end
    
    it "should generate params { :controller => 'admin/assigned_assets', action => 'select', :portfolio_id => '1' } from POST /portfolios/1/assigned_assets/select" do
      params_from(:post, "/admin/portfolios/1/assigned_assets/select").should == {:controller => "admin/assigned_assets", :action => "select", :portfolio_id => '1'}
    end
    
    it "should generate params { :controller => 'admin/assigned_assets', action => 'deselect', :portfolio_id => '1' } from DELETE /portfolios/1/assigned_assets/deselect" do
      params_from(:delete, "/admin/portfolios/1/assigned_assets/deselect").should == {:controller => "admin/assigned_assets", :action => "deselect", :portfolio_id => '1'}
    end
    
    it "should generate params { :controller => 'admin/assigned_assets', action => 'clear', :portfolio_id => '1' } from DELETE /portfolios/1/assigned_assets/clear" do
      params_from(:delete, "/admin/portfolios/1/assigned_assets/clear").should == {:controller => "admin/assigned_assets", :action => "clear", :portfolio_id => '1'}
    end
    
    it "should generate params { :controller => 'admin/assigned_assets', action => 'reorder', :portfolio_id => '1' } from GET /admin/portfolios/1/assigned_assets/reorder" do
      params_from(:get, "/admin/portfolios/1/assigned_assets/reorder").should == {:controller => "admin/assigned_assets", :action => "reorder", :portfolio_id => "1"}
    end
    
    it "should generate params { :controller => 'admin/assigned_assets', action => 'update_order', :portfolio_id => '1' } from PUT /admin/portfolios/1/assigned_assets/update_order" do
      params_from(:put, "/admin/portfolios/1/assigned_assets/update_order").should == {:controller => "admin/assigned_assets", :action => "update_order", :portfolio_id => "1"}
    end
  end
end
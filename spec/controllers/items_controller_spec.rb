require File.dirname(__FILE__) + '/../spec_helper'

describe ItemsController do
  define_models :items_controller do
    model Portfolio do
      stub :one, :site => all_stubs(:site), :lft => 1, :rgt => 2
    end
    model Asset do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
    end
    model AssignedAsset do
      stub :one, :portfolio => all_stubs(:one_portfolio), :asset => all_stubs(:one_asset), :marker => 'display'
      stub :two, :portfolio => all_stubs(:one_portfolio), :asset => all_stubs(:two_asset), :marker => 'display'
    end
  end
  
  before(:each) do
    activate_site(:default)
  end

  describe "handling GET /portfolios/1/items/1" do
    define_models :items_controller
    
    def do_get
      get :show, :id => assigned_assets(:one).id, :portfolio_id => portfolios(:one).id
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should render the portfolio_item template" do
      do_get
      response.should render_template('portfolio_item')
    end
    
    it "should assign item" do
      do_get
      assigns[:item].should == assigned_assets(:one)
    end
    
    it "should assign portfolio" do
      do_get
      assigns[:portfolio].should == portfolios(:one)
    end
  end
    
  describe "site, login, and admin requirements" do
    define_models :items_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :show, :id => assigned_assets(:one).id, :portfolio_id => portfolios(:one).id }])
    end
        
    it "should not require login" do
      test_login_requirement(false, false, [
        lambda { get :show, :id => assigned_assets(:one).id, :portfolio_id => portfolios(:one).id }])
    end
  end
end

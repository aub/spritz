require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AssignedAssetsController do
  
  define_models :assigned_assets_controller do
    model Portfolio do
      stub :one, :site => all_stubs(:site)
    end
    model Asset do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
    end
    model AssignedAsset do
      stub :one, :portfolio => all_stubs(:one_portfolio), :asset => all_stubs(:one_asset)
    end
  end
  
  before(:each) do
    activate_site(:default)
    login_as(:admin)
  end
  
  describe "handling POST /portfolios/1/assigned_assets" do
    define_models :assigned_assets_controller
    
    describe "with successful save" do
      define_models :assigned_assets_controller
    
      def do_post
        post :create, :portfolio_id => portfolios(:one).id, :asset_id => assets(:two).id
      end

      it "should create a new assigned_asset" do
        lambda { do_post }.should change(AssignedAsset, :count).by(1)
      end
      
      it "should assign the asset to the correct portfolio" do
        lambda { do_post }.should change(portfolios(:one).assets, :count).by(1)
      end
  
      it "should redirect to the portfolio" do
        do_post
        response.should redirect_to(edit_admin_portfolio_path(portfolios(:one)))
      end 
    end
    
    describe "with failed save" do
      define_models :assigned_assets_controller

      def do_post
        post :create, :portfolio_id => portfolios(:one).id, :asset_id => nil
      end
      
      it "should redirect to the portfolio path" do
        do_post
        response.should redirect_to(edit_admin_portfolio_path(portfolios(:one)))
      end
      
      it "should not create a new assigned asset" do
        lambda { do_post }.should_not change(AssignedAsset, :count)
      end
    end
  end

  describe "handling DELETE /portfolios/1/assigned_assets/1" do
    define_models :assigned_assets_controller
      
    def do_delete
      delete :destroy, :portfolio_id => portfolios(:one).id, :id => assigned_assets(:one).id
    end

    it "should call destroy on the found attached asset" do
      lambda { do_delete }.should change(AssignedAsset, :count).by(-1)
    end
    
    it "should remove the asset from the correct portfolio" do
      lambda { do_delete }.should change(portfolios(:one).assets, :count).by(-1)
    end
  
    it "should redirect to the portfolio" do
      do_delete
      response.should redirect_to(edit_admin_portfolio_path(portfolios(:one)))
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :assigned_assets_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { post :create, :portfolio_id => portfolios(:one).id, :asset_id => assets(:two).id },
        lambda { delete :destroy, :portfolio_id => portfolios(:one).id, :id => assigned_assets(:one).id }])
    end
    
    it "should require regular login" do
      test_login_requirement(true, false, [
        lambda { post :create, :portfolio_id => portfolios(:one).id, :asset_id => assets(:two).id },
        lambda { delete :destroy, :portfolio_id => portfolios(:one).id, :id => assigned_assets(:one).id }])
    end
  end  
end
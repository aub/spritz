require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AssignedAssetsController do
  
  define_models :assigned_assets_controller do
    model Portfolio do
      stub :one, :site => all_stubs(:site), :lft => 1, :rgt => 2
    end
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'fake1'
      stub :two, :site => all_stubs(:site), :filename => 'fake2'
    end
    model AssignedAsset do
      stub :one, :portfolio => all_stubs(:one_portfolio), :asset => all_stubs(:one_asset)
    end
  end
  
  before(:each) do
    activate_site(:default)
  end
  
  describe "handling GET /portfolios/1/assigned_assets/new" do
    define_models :assigned_assets_controller

    before(:each) do
      login_as(:admin)
    end
    
    def do_get
      get :new, :portfolio_id => portfolios(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should not save the new assigned_asset" do
      do_get
      assigns[:assigned_asset].should be_new_record
    end
  
    it "should assign the new assigned asset for the view" do
      do_get
      assigns[:assigned_asset].should be_an_instance_of(AssignedAsset)
    end
  end  
  
  describe "handling POST /portfolios/1/assigned_assets" do
    define_models :assigned_assets_controller
    
    before(:each) do
      login_as(:admin)
    end
    
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
      
    before(:each) do
      login_as(:admin)
    end

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
        lambda { get :new, :portfolio_id => portfolios(:one).id },
        lambda { post :create, :portfolio_id => portfolios(:one).id, :asset_id => assets(:two).id },
        lambda { delete :destroy, :portfolio_id => portfolios(:one).id, :id => assigned_assets(:one).id }])
    end
    
    it "should require regular login" do
      test_login_requirement(true, false, [
        lambda { get :new, :portfolio_id => portfolios(:one).id },
        lambda { post :create, :portfolio_id => portfolios(:one).id, :asset_id => assets(:two).id },
        lambda { delete :destroy, :portfolio_id => portfolios(:one).id, :id => assigned_assets(:one).id }])
    end
  end  
end
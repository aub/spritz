require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HomeImageController do
  define_models :home_image_controller do
    model Asset do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  before(:each) do
    activate_site(:default)
    
    # Create a few cache items.
    @a = CacheItem.for(sites(:default), '/', [sites(:default)])
    @b = CacheItem.for(sites(:default), 'a/b', [sites(:default)])
  end  

  describe "handling GET /home/home_image/edit" do
    define_models :home_image_controller

    before(:each) do
      login_as(:admin)
    end
    
    def do_get
      get :edit
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should assign the site for the view" do
      do_get
      assigns[:site].should == sites(:default)
    end
  
    it "should assign a page of assets" do
      do_get
      assigns[:assets].should == sites(:default).assets.paginate(:page => params[:page], :per_page => 18)
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end  
  end

  describe "handling PUT /home/home_image" do
    define_models :home_image_controller

    before(:each) do
      login_as(:admin)
    end

    describe "with successful update" do
      define_models :home_image_controller
      
      def do_put
        put :update, :asset_id => assets(:one).id
      end

      it "should update the home image of the site" do
        do_put
        sites(:default).reload.assigned_home_image.asset_id.should == assets(:one).id
      end

      it "should assign the site for the view" do
        do_put
        assigns(:site).should == sites(:default)
      end

      it "should redirect to the home editor page" do
        do_put
        response.should redirect_to(edit_admin_home_path)
      end
      
      it "should expire the home page" do
        lambda { do_put }.should expire([@a])
      end
    end
    
    describe "with failed update" do
      define_models :home_image_controller
      
      def do_put
        # the asset id has to exist, so this will fail
        put :update, :assigned_asset => {}
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
      
      it "should assign the site for the view" do
        do_put
        assigns(:site).should == sites(:default)
      end
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :home_image_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :edit },
        lambda { put :update, :assigned_asset => { :asset_id => 1 } }])
    end
    
    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :edit },
        lambda { put :update, :assigned_asset => { :asset_id => 1 } }])
    end
  end  
end
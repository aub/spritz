require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HomeController do
  define_models :home_controller
  
  before(:each) do
    activate_site(:default)
    
    # Create a few cache items.
    @a = CacheItem.for(sites(:default), '/', [sites(:default)])
    @b = CacheItem.for(sites(:default), 'a/b', [sites(:default)])
  end  

  describe "handling GET /home/edit" do
    define_models :home_controller

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
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end  
  end

  describe "handling PUT /home" do
    define_models :home_controller

    before(:each) do
      login_as(:admin)
    end

    describe "with successful update" do
      define_models :home_controller
      
      def do_put
        put :update, :site => { :home_text => 'heya', :home_news_item_count => 3 }
      end

      it "should update the home text of the site" do
        do_put
        sites(:default).reload.home_text.should == 'heya'
      end
      
      it "should update the news item count of the site" do
        do_put
        sites(:default).reload.home_news_item_count.should == 3
      end

      it "should assign the site for the view" do
        do_put
        assigns(:site).should == sites(:default)
      end

      it "should redirect to the edit page" do
        do_put
        response.should redirect_to(edit_admin_home_path)
      end
      
      it "should expire the home page" do
        lambda { do_put }.should expire([@a])
      end
    end
    
    describe "with failed update" do
      define_models :home_controller
      
      def do_put
        # the news item count must be an integer, so this will fail.
        put :update, :site => { :home_text => 'ab', :home_news_item_count => 'ack' }
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
    define_models :home_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :edit },
        lambda { put :update, :site => {} }])
    end
    
    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :edit },
        lambda { put :update, :site => {} }])
    end
  end  
end
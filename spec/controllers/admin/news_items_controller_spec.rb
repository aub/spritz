require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::NewsItemsController do
  define_models :news_items_controller do
    model NewsItem do
      stub :one, :site => all_stubs(:site), :position => 1
      stub :two, :site => all_stubs(:site), :position => 2
      stub :tre, :site => all_stubs(:site), :position => 3
      stub :four, :site => all_stubs(:other_site)
    end
  end
  
  before(:each) do
    activate_site(:default)
    
    # Create a few cache items.
    @a = CacheItem.for(sites(:default), 'a', [news_items(:one)])
    @b = CacheItem.for(sites(:default), 'b', [sites(:default)])
    @c = CacheItem.for(sites(:default), 'c', [news_items(:one), sites(:default)])
    @d = CacheItem.for(sites(:default), 'd', [sites(:default).news_items])
    @e = CacheItem.for(sites(:default), 'e', [news_items(:two)])
  end
  
  describe "handling GET /admin/news_items" do
    define_models :news_items_controller
    
    before(:each) do
      login_as(:admin)
    end

    def do_get
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render index template" do
      do_get
      response.should render_template('index')
    end
  
    it "should assign the found admin_news_items for the view" do
      do_get
      assigns[:news_items].sort_by(&:id).should == [news_items(:one), news_items(:two), news_items(:tre)].sort_by(&:id)
    end
  end

  describe "handling GET /admin_news_items/1" do
    define_models :news_items_controller
    
    before(:each) do
      login_as(:admin)
    end

    def do_get
      get :show, :id => news_items(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should assign the found news_item for the view" do
      do_get
      assigns[:news_item].should == news_items(:one)
    end
    
    it "should not find news items that are in another site" do
      get :show, :id => news_items(:four)
      response.should be_missing
    end
  end

  describe "handling GET /admin/news_items/new" do
    define_models :news_items_controller
    
    before(:each) do
      login_as(:admin)
    end
  
    def do_get
      get :new
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
    
    it "should assign the new news_item for the view" do
      do_get
      assigns[:news_item].should be_an_instance_of(NewsItem)
    end
    
    it "should not save the new news_item" do
      do_get
      assigns[:news_item].should be_new_record
    end
  end

  describe "handling GET /admin/news_items/1/edit" do
    define_models :news_items_controller
    
    before(:each) do
      login_as(:admin)
    end

    def do_get
      get :edit, :id => news_items(:one)
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should assign the found NewsItem for the view" do
      do_get
      assigns[:news_item].should == news_items(:one)
    end
    
    it "should not find news items that are in a different site" do
      get :edit, :id => news_items(:four)
      response.should be_missing
    end
  end

  describe "handling POST /admin/news_items" do
    define_models :news_items_controller
    
    before(:each) do
      login_as(:admin)
    end
    
    describe "with successful save" do
      define_models :news_items_controller
      
      def do_post
        post :create, :news_item => { :title => 'They wrote an article about me' }
      end
  
      it "should create a new news_item" do
        lambda { do_post }.should change(NewsItem, :count).by(1)
      end

      it "should redirect to the news_item list" do
        do_post
        response.should redirect_to(admin_news_items_path)
      end
      
      it "should set the position to be at the end of the list" do
        prev_last = sites(:default).news_items.last
        do_post
        assigns[:news_item].position.should == prev_last.position + 1
      end
      
      it "should set the position to be 1 if there are no items in the list" do
        sites(:default).news_items.each(&:destroy)
        sites(:default).news_items.reload
        do_post
        assigns[:news_item].position.should == 1
      end
      
      it "should expire caches related to the site's list of news items" do
        lambda { do_post }.should expire([@d])
      end
    end
    
    describe "with failed save" do
      define_models :news_items_controller
      
      def do_post
        post :create, :news_item => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
      it "should not create a new news item" do
        lambda { do_post }.should_not change(NewsItem, :count)
      end
    end
  end

  describe "handling PUT /admin/news_items/1" do
    define_models :news_items_controller
    
    before(:each) do
      login_as(:admin)
    end
    
    describe "with successful update" do
      define_models :news_items_controller
      
      def do_put
        put :update, :id => news_items(:one), :news_item => { :title => 'changed' }
      end

      it "should update the found news_item" do
        do_put
        news_items(:one).reload.title.should == 'changed'
      end

      it "should assign the found news_item for the view" do
        do_put
        assigns(:news_item).should == news_items(:one)
      end

      it "should redirect to the news_items list" do
        do_put
        response.should redirect_to(admin_news_items_path)
      end

      it "should expire caches related to the news item" do
        lambda { do_put }.should expire([@a, @c])
      end
    end
    
    describe "with failed update" do
      define_models :news_items_controller
      
      def do_put
        title = ''
        101.times { title << 'a' }
        put :update, :id => news_items(:one).id, :news_item => { :title => title }
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
    end
  end

  describe "handling PUT /news_items/reorder" do
    define_models :news_items_controller

    before(:each) do
      login_as(:admin)
    end

    def do_put
      put :reorder, :news_items => [ news_items(:tre).id, news_items(:one).id, news_items(:two).id ]
    end

    it "should render nothing" do
      do_put
      response.should be_success
      response.body.should be_blank
    end

    it "should update the news_item order" do
      do_put
      sites(:default).news_items.reload.should == [ news_items(:tre), news_items(:one), news_items(:two) ]
    end
    
    it "should expire caches related to the news items" do
      lambda { do_put }.should expire([@a, @c, @e])
    end
  end

  describe "handling DELETE /admin/news_items/1" do
    define_models :news_items_controller
    
    before(:each) do
      login_as(:admin)
    end
  
    def do_delete
      delete :destroy, :id => news_items(:one).id
    end

    it "should call destroy on the found news_item" do
      lambda { do_delete }.should change(NewsItem, :count).by(-1)
    end
  
    it "should redirect to the news_items list" do
      do_delete
      response.should redirect_to(admin_news_items_url)
    end
    
    it "should expire caches related to the news items and the site's list of news items" do
      lambda { do_delete }.should expire([@a, @c, @d])
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :news_items_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { get :edit, :id => news_items(:one).id },
        lambda { put :update, :id => news_items(:one).id, :news_item => {} },
        lambda { put :reorder },
        lambda { get :new },
        lambda { post :create, :news_item => {} },
        lambda { delete :destroy, :id => news_items(:one).id }])
    end
    
    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :index },
        lambda { get :edit, :id => news_items(:one).id },
        lambda { put :update, :id => news_items(:one).id, :news_item => {} },
        lambda { put :reorder },
        lambda { get :new },
        lambda { post :create, :news_item => {} },
        lambda { delete :destroy, :id => news_items(:one).id }])
    end
  end  
end
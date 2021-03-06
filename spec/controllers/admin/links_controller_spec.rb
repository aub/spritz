require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::LinksController do
  
  define_models :links_controller do
    model Link do
      stub :one, :site => all_stubs(:site), :position => 1
      stub :two, :site => all_stubs(:site), :position => 2
      stub :tre, :site => all_stubs(:site), :position => 3
      stub :four, :site => all_stubs(:other_site), :position => 1
    end
  end
  
  before(:each) do
    activate_site(:default)
    
    # Create a few cache items.
    @a = CacheItem.for(sites(:default), 'a', [links(:one)])
    @b = CacheItem.for(sites(:default), 'b', [sites(:default)])
    @c = CacheItem.for(sites(:default), 'c', [links(:one), sites(:default)])
    @d = CacheItem.for(sites(:default), 'd', [sites(:default).links])
    @e = CacheItem.for(sites(:default), 'e', [links(:two)])
  end
  
  describe "handling GET /links" do
    define_models :links_controller

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
  
    it "should assign the found links for the view" do
      do_get
      assigns[:links].sort_by(&:id).should == [links(:one), links(:two), links(:tre)].sort_by(&:id)
    end
  end

  describe "handling GET /links/1" do
    define_models :links_controller

    before(:each) do
      login_as(:admin)
    end
    
    def do_get
      get :show, :id => links(:one).id
    end

    it "should be missing" do
      do_get
      response.should be_missing
    end
  end

  describe "handling GET /links/new" do
    define_models :links_controller

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
  
    it "should not save the new link" do
      do_get
      assigns[:link].should be_new_record
    end
  
    it "should assign the new link for the view" do
      do_get
      assigns[:link].should be_an_instance_of(Link)
    end
    
    it "should create a link as a child of the site" do
      do_get
      assigns[:link].site_id.should == sites(:default).id
    end
  end

  describe "handling GET /links/1/edit" do
    define_models :links_controller

    before(:each) do
      login_as(:admin)
    end
    
    def do_get
      get :edit, :id => links(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should assign the found Link for the view" do
      do_get
      assigns[:link].should == links(:one)
    end
  end

  describe "handling POST /links" do
    define_models :links_controller

    before(:each) do
      login_as(:admin)
    end
    
    describe "with successful save" do
      define_models :links_controller
    
      def do_post
        post :create, :link => { :url => 'hack', :title => 'ack' }
      end

      it "should create a new link" do
        lambda { do_post }.should change(Link, :count).by(1)
      end
  
      it "should redirect to the links list" do
        do_post
        response.should redirect_to(admin_links_url)
      end

      it "should set the position of the link" do
        prev_last = sites(:default).links.last
        do_post
        assigns[:link].position.should == prev_last.position + 1
      end
      
      it "should put the link at the beginning of the list if there are none" do
        sites(:default).links.each(&:destroy)
        sites(:default).links.reload
        do_post
        assigns[:link].position.should == 1
      end
      
      it "should expire caches related to the site's list of links" do
        lambda { do_post }.should expire([@d])
      end
    end

    describe "with failed save" do
      define_models :links_controller

      def do_post
        post :create, :link => {}
      end

      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
    end
  end

  describe "handling PUT /links/1" do
    define_models :links_controller

    before(:each) do
      login_as(:admin)
    end

    describe "with successful update" do
      define_models :links_controller
      
      def do_put
        put :update, :id => links(:one).id, :link => { :url => 'heya', :title => 'bya' }
      end

      it "should update the found link" do
        do_put
        links(:one).reload.url.should == 'http://heya' # Because the link will append http://
      end

      it "should assign the found link for the view" do
        do_put
        assigns(:link).should == links(:one)
      end

      it "should redirect to the links list" do
        do_put
        response.should redirect_to(admin_links_url)
      end
      
      it "should expire caches related to the link" do
        lambda { do_put }.should expire([@a, @c])
      end
    end
    
    describe "with failed update" do
      define_models :links_controller
      
      def do_put
        put :update, :id => links(:one).id, :link => { :url => 'ab' }
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
    end
  end
  
  describe "handling PUT /links/reorder" do
    define_models :links_controller

    before(:each) do
      login_as(:admin)
    end

    def do_put
      put :reorder, :links => [ links(:tre).id, links(:one).id, links(:two).id ]
    end

    it "should render nothing" do
      do_put
      response.should be_success
      response.body.should be_blank
    end

    it "should update the link order" do
      do_put
      sites(:default).links.reload.should == [ links(:tre), links(:one), links(:two) ]
    end
    
    it "should expire caches related to the links" do
      lambda { do_put }.should expire([@a, @c, @e])
    end
  end

  describe "handling DELETE /links/1" do
    define_models :links_controller

    before(:each) do
      login_as(:admin)
    end
      
    def do_delete
      delete :destroy, :id => links(:one).id
    end

    it "should call destroy on the found link" do
      lambda { do_delete }.should change(Link, :count).by(-1)
    end
  
    it "should redirect to the links list" do
      do_delete
      response.should redirect_to(admin_links_url)
    end
    
    it "should expire caches related to the link and the site's list of links" do
      lambda { do_delete }.should expire([@a, @c, @d])
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :links_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { get :edit, :id => links(:one).id },
        lambda { put :update, :id => links(:one).id, :link => {} },
        lambda { put :reorder },
        lambda { get :new },
        lambda { post :create, :link => {} },
        lambda { delete :destroy, :id => links(:one).id }])
    end
    
    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :index },
        lambda { get :edit, :id => links(:one).id },
        lambda { put :update, :id => links(:one).id, :link => {} },
        lambda { put :reorder },
        lambda { get :new },
        lambda { post :create, :link => {} },
        lambda { delete :destroy, :id => links(:one).id }])
    end
  end  
end
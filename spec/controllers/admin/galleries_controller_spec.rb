require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::GalleriesController do
  
  define_models :galleries_controller do
    model Gallery do
      stub :one, :site => all_stubs(:site), :position => 1
      stub :two, :site => all_stubs(:site), :position => 2
      stub :tre, :site => all_stubs(:site), :position => 3
      stub :four, :site => all_stubs(:other_site), :position => 1
    end
  end
  
  before(:each) do
    activate_site(:default)
    
    # Create a few cache items.
    @a = CacheItem.for(sites(:default), 'a', [galleries(:one)])
    @b = CacheItem.for(sites(:default), 'b', [sites(:default)])
    @c = CacheItem.for(sites(:default), 'c', [galleries(:one), sites(:default)])
    @d = CacheItem.for(sites(:default), 'd', [sites(:default).galleries])
    @e = CacheItem.for(sites(:default), 'e', [galleries(:two)])
  end
  
  describe "handling GET /admin/galleries" do
    define_models :galleries_controller

    before(:each) do
      login_as :admin
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
  
    it "should assign the found galleries for the view" do
      do_get
      assigns[:galleries].should == [galleries(:one), galleries(:two), galleries(:tre)]
    end
  end

  describe "handling GET /admin/galleries.xml" do
    define_models :galleries_controller
    
    before(:each) do
      authorize_as :admin
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the found galleries as xml" do
      do_get
      response.body.should == sites(:default).galleries.to_xml
    end
  end

  describe "handling GET /admin/galleries/1" do
    define_models :galleries_controller
    
    before(:each) do
      login_as :admin
    end
  
    def do_get
      get :show, :id => galleries(:one).id
    end

    it "should be missing" do
      do_get
      response.should be_missing
    end
  end

  describe "handling GET /admin/galleries/1.xml" do
    define_models :galleries_controller
    
    before(:each) do
      authorize_as :admin
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => galleries(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should not found galleries from another site" do
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => galleries(:four)
      response.should be_missing
    end
  end

  describe "handling GET /admin/galleries/new" do
    define_models :galleries_controller
    
    before(:each) do
      login_as :admin
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
  
    it "should create an new gallery" do
      do_get
      assigns[:gallery].should be_new_record
    end
  
    it "should assign the new gallery for the view" do
      do_get
      assigns[:gallery].should be_an_instance_of(Gallery)
    end
    
    it "should create the gallery as a child of the site" do
      do_get
      assigns[:gallery].site.should == sites(:default)
    end
  end

  describe "handling GET /admin_galleries/1/edit" do
    define_models :galleries_controller
    
    before(:each) do
      login_as :admin
    end
  
    def do_get
      get :edit, :id => galleries(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the gallery requested" do
      do_get
      assigns[:gallery].should == galleries(:one)
    end
  
    it "should not find galleries from other sites" do
      get :edit, :id => galleries(:four).id
      response.should be_missing
    end
  end

  describe "handling POST /admin/galleries" do
    define_models :galleries_controller
    
    before(:each) do
      login_as :admin
    end
    
    describe "with successful save" do
      define_models :galleries_controller
      
      def do_post
        post :create, :gallery => { :name => 'booya' }
      end
  
      it "should create a new gallery" do
        lambda { do_post }.should change(Gallery, :count).by(1)
      end
  
      it "should redirect to the galleries list" do
        do_post
        response.should redirect_to(admin_galleries_url)
      end

      it "should assign the gallery to the active site" do
        do_post
        assigns[:gallery].site.should == sites(:default)
      end

      it "should set the position of the gallery" do
        prev_last = sites(:default).galleries.last
        do_post
        assigns[:gallery].position.should == prev_last.position + 1
      end
      
      it "should put the gallery at the beginning of the list if there are none" do
        sites(:default).galleries.each(&:destroy)
        sites(:default).galleries.reload
        do_post
        assigns[:gallery].position.should == 1
      end
      
      it "should expire caches related to the site's list of galleries" do
        lambda { do_post }.should expire([@d])
      end
    end
    
    describe "with failed save" do
      define_models :galleries_controller
      
      def do_post
        post :create, :gallery => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
    end
  end

  describe "handling PUT /admin/galleries/1" do
    define_models :galleries_controller

    before(:each) do
      login_as(:admin)
    end

    describe "with successful update" do
      define_models :galleries_controller
      
      def do_put
        put :update, :id => galleries(:one).id, :gallery => { :name => 'heya' }
      end

      it "should update the found gallery" do
        do_put
        galleries(:one).reload.name.should == 'heya'
      end

      it "should assign the found gallery for the view" do
        do_put
        assigns(:gallery).should == galleries(:one)
      end

      it "should redirect to the galleries list" do
        do_put
        response.should redirect_to(admin_galleries_url)
      end
      
      it "should fail for galleries that are not in the active site" do
        put :update, :id => galleries(:four).id, :gallery => { :name => 'heya' }
        response.should be_missing
      end
      
      it "should expire caches related to the gallery" do
        lambda { do_put }.should expire([@a, @c])
      end
    end
    
    describe "with failed update" do
      define_models :galleries_controller
      
      def do_put
        put :update, :id => galleries(:one).id, :gallery => { :name => '' }
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
    end
  end

  describe "handling PUT /galleries/reorder" do
    define_models :galleries_controller

    before(:each) do
      login_as(:admin)
    end

    def do_put
      put :reorder, :galleries => [ galleries(:tre).id, galleries(:one).id, galleries(:two).id ]
    end

    it "should render nothing" do
      do_put
      response.should be_success
      response.body.should be_blank
    end

    it "should update the gallery order" do
      do_put
      sites(:default).galleries.reload.should == [ galleries(:tre), galleries(:one), galleries(:two) ]
    end

    it "should expire caches related to the galleries" do
      lambda { do_put }.should expire([@a, @c, @e])
    end
  end

  describe "handling DELETE /galleries/1" do
    define_models :galleries_controller

    before(:each) do
      login_as(:admin)
    end

    def do_delete
      delete :destroy, :id => galleries(:one).id
    end

    it "should call destroy on the found gallery" do
      lambda { do_delete }.should change(Gallery, :count).by(-1)
    end

    it "should redirect to the galleries list" do
      do_delete
      response.should redirect_to(admin_galleries_url)
    end

    it "should fail if the gallery is not in the active site" do
      delete :destroy, :id => galleries(:four).id
      response.should be_missing
    end

    it "should expire caches related to the gallery and the site's list of galleries" do
      lambda { do_delete }.should expire([@a, @c, @d])
    end
  end

  describe "site, login, and admin requirements" do
    define_models :galleries_controller

    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { get :edit, :id => galleries(:one).id },
        lambda { put :update, :id => galleries(:one).id, :gallery => {} },
        lambda { put :reorder },
        lambda { get :new },
        lambda { post :create, :gallery => {} },
        lambda { delete :destroy, :id => galleries(:one).id }])
    end

    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :index },
        lambda { get :edit, :id => galleries(:one).id },
        lambda { put :update, :id => galleries(:one).id, :gallery => {} },
        lambda { put :reorder },
        lambda { get :new },
        lambda { post :create, :gallery => {} },
        lambda { delete :destroy, :id => galleries(:one).id }])
    end
  end  
end

require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::LinksController do
  
  define_models :links_controller do
    model Link do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
      stub :tre, :site => all_stubs(:other_site)
    end
  end
  
  before(:each) do
    activate_site(:default)
    login_as(:admin)
  end
  
  describe "handling GET /links" do
    define_models :links_controller

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
      assigns[:links].sort_by(&:id).should == [links(:one), links(:two)].sort_by(&:id)
    end
  end

  describe "handling GET /links.xml" do
    define_models :links_controller
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the found links as xml" do
      do_get
      response.body.should == sites(:default).links.to_xml
    end
  end

  describe "handling GET /links/1" do
    define_models :links_controller
    
    def do_get
      get :show, :id => links(:one).id
    end

    it "should be missing" do
      do_get
      response.should be_missing
    end
  end

  describe "handling GET /links/1.xml" do
    define_models :links_controller
    
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => links(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render the found link as xml" do
      do_get
      response.body.should == links(:one).to_xml
    end
    
    it "should render not found for links not in the site" do
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => links(:tre).id
      response.should be_missing
    end
  end

  describe "handling GET /links/new" do
    define_models :links_controller
    
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
    
    describe "with successful save" do
      define_models :links_controller
    
      def do_post
        post :create, :link => {}
      end

      it "should create a new link" do
        lambda { do_post }.should change(Link, :count).by(1)
      end
  
      it "should redirect to the links list" do
        do_post
        response.should redirect_to(admin_links_url)
      end
      
    end
  end

  describe "handling PUT /links/1" do
    define_models :links_controller

    describe "with successful update" do
      define_models :links_controller
      
      def do_put
        put :update, :id => links(:one).id, :link => { :url => 'heya' }
      end

      it "should update the found link" do
        do_put
        links(:one).reload.url.should == 'heya'
      end

      it "should assign the found link for the view" do
        do_put
        assigns(:link).should == links(:one)
      end

      it "should redirect to the links list" do
        do_put
        response.should redirect_to(admin_links_url)
      end
    end
  end

  describe "handling DELETE /links/1" do
    define_models :links_controller
      
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
  end
  
  describe "site, login, and admin requirements" do
    define_models :links_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { get :edit, :id => links(:one).id },
        lambda { put :update, :id => links(:one).id, :link => {} },
        lambda { get :new },
        lambda { post :create, :link => {} },
        lambda { delete :destroy, :id => links(:one).id }])
    end
    
    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :index },
        lambda { get :edit, :id => links(:one).id },
        lambda { put :update, :id => links(:one).id, :link => {} },
        lambda { get :new },
        lambda { post :create, :link => {} },
        lambda { delete :destroy, :id => links(:one).id }])
    end
  end  
end
require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::LinksController do
  
  define_models :links_controller
  
  before(:each) do
    activate_site(:default)
    login_as(:admin)
  end
  
  describe "handling GET /links" do
    define_models :links_controller

    before(:each) do
      @link = mock_model(Link)
      Link.stub!(:find).and_return([@link])
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
  
    it "should find all links" do
      Link.should_receive(:find).with(:all).and_return([@link])
      do_get
    end
  
    it "should assign the found links for the view" do
      do_get
      assigns[:links].should == [@link]
    end
  end

  describe "handling GET /links.xml" do
    define_models :links_controller
    
    before(:each) do
      @link = mock_model(Link, :to_xml => "XML")
      Link.stub!(:find).and_return(@link)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all links" do
      Link.should_receive(:find).with(:all).and_return([@link])
      do_get
    end
  
    it "should render the found links as xml" do
      @link.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /links/1" do
    define_models :links_controller
    
    before(:each) do
      @link = mock_model(Link)
      Link.stub!(:find).and_return(@link)
    end
  
    def do_get
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should find the link requested" do
      Link.should_receive(:find).with("1").and_return(@link)
      do_get
    end
  
    it "should assign the found link for the view" do
      do_get
      assigns[:link].should equal(@link)
    end
  end

  describe "handling GET /links/1.xml" do
    define_models :links_controller
    
    before(:each) do
      @link = mock_model(Link, :to_xml => "XML")
      Link.stub!(:find).and_return(@link)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the link requested" do
      Link.should_receive(:find).with("1").and_return(@link)
      do_get
    end
  
    it "should render the found link as xml" do
      @link.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /links/new" do
    define_models :links_controller
    
    before(:each) do
      @link = mock_model(Link)
      Link.stub!(:new).and_return(@link)
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
  
    it "should create an new link" do
      Link.should_receive(:new).and_return(@link)
      do_get
    end
  
    it "should not save the new link" do
      @link.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new link for the view" do
      do_get
      assigns[:link].should equal(@link)
    end
  end

  describe "handling GET /links/1/edit" do
    define_models :links_controller
    
    before(:each) do
      @link = mock_model(Link)
      Link.stub!(:find).and_return(@link)
    end
  
    def do_get
      get :edit, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the link requested" do
      Link.should_receive(:find).and_return(@link)
      do_get
    end
  
    it "should assign the found Link for the view" do
      do_get
      assigns[:link].should equal(@link)
    end
  end

  describe "handling POST /links" do
    define_models :links_controller
    
    before(:each) do
      @link = mock_model(Link, :to_param => "1")
      Link.stub!(:new).and_return(@link)
    end
    
    describe "with successful save" do
      define_models :links_controller
    
      def do_post
        @link.should_receive(:save).and_return(true)
        post :create, :link => {}
      end
  
      it "should create a new link" do
        Link.should_receive(:new).with({}).and_return(@link)
        do_post
      end

      it "should redirect to the new link" do
        do_post
        response.should redirect_to(admin_link_url("1"))
      end
      
    end
    
    describe "with failed save" do
      define_models :links_controller
      
      def do_post
        @link.should_receive(:save).and_return(false)
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
      @link = mock_model(Link, :to_param => "1")
      Link.stub!(:find).and_return(@link)
    end
    
    describe "with successful update" do
      define_models :links_controller
      
      def do_put
        @link.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the link requested" do
        Link.should_receive(:find).with("1").and_return(@link)
        do_put
      end

      it "should update the found link" do
        do_put
        assigns(:link).should equal(@link)
      end

      it "should assign the found link for the view" do
        do_put
        assigns(:link).should equal(@link)
      end

      it "should redirect to the link" do
        do_put
        response.should redirect_to(admin_link_url("1"))
      end

    end
    
    describe "with failed update" do
      define_models :links_controller
      
      def do_put
        @link.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /links/1" do
    define_models :links_controller
    
    before(:each) do
      @link = mock_model(Link, :destroy => true)
      Link.stub!(:find).and_return(@link)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the link requested" do
      Link.should_receive(:find).with("1").and_return(@link)
      do_delete
    end
  
    it "should call destroy on the found link" do
      @link.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the links list" do
      do_delete
      response.should redirect_to(admin_links_url)
    end
  end
end
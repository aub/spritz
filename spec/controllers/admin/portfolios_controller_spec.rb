require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PortfoliosController do
  
  define_models :portfolios_controller do
    model Site do
      stub :other
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
      stub :tre, :site => all_stubs(:other_site)
    end
  end
  
  before(:each) do
    activate_site(:default)
    login_as(:admin)
  end
    
  describe "handling GET /admin/portfolios" do
    define_models :portfolios_controller
    
    before(:each) do
      @portfolio = mock_model(Portfolio)
      Portfolio.stub!(:find).and_return([@portfolio])
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
  
    it "should find all portfolios" do
      Portfolio.should_receive(:find).with(:all).and_return([@portfolio])
      do_get
    end
  
    it "should assign the found portfolios for the view" do
      do_get
      assigns[:portfolios].should == [@portfolio]
    end
  end

  describe "handling GET /admin/portfolios.xml" do
    define_models :portfolios_controller
    
    before(:each) do
      @portfolio = mock_model(Portfolio, :to_xml => "XML")
      Portfolio.stub!(:find).and_return(@portfolio)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should find all portfolios" do
      Portfolio.should_receive(:find).with(:all).and_return([@portfolio])
      do_get
    end
  
    it "should render the found portfolios as xml" do
      @portfolio.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /admin/portfolios/1" do
    define_models :portfolios_controller
    
    before(:each) do
      @portfolio = mock_model(Portfolio)
      Portfolio.stub!(:find).and_return(@portfolio)
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
  
    it "should find the portfolio requested" do
      Portfolio.should_receive(:find).with("1").and_return(@portfolio)
      do_get
    end
  
    it "should assign the found portfolio for the view" do
      do_get
      assigns[:portfolio].should equal(@portfolio)
    end
  end

  describe "handling GET /admin/portfolios/1.xml" do
    define_models :portfolios_controller
    
    before(:each) do
      @portfolio = mock_model(Portfolio, :to_xml => "XML")
      Portfolio.stub!(:find).and_return(@portfolio)
    end
  
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => "1"
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should find the portfolio requested" do
      Portfolio.should_receive(:find).with("1").and_return(@portfolio)
      do_get
    end
  
    it "should render the found portfolio as xml" do
      @portfolio.should_receive(:to_xml).and_return("XML")
      do_get
      response.body.should == "XML"
    end
  end

  describe "handling GET /admin/portfolios/new" do
    define_models :portfolios_controller
    
    before(:each) do
      @portfolio = mock_model(Portfolio)
      Portfolio.stub!(:new).and_return(@portfolio)
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
  
    it "should create an new portfolio" do
      Portfolio.should_receive(:new).and_return(@portfolio)
      do_get
    end
  
    it "should not save the new portfolio" do
      @portfolio.should_not_receive(:save)
      do_get
    end
  
    it "should assign the new portfolio for the view" do
      do_get
      assigns[:portfolio].should equal(@portfolio)
    end
  end

  describe "handling GET /admin/portfolios/1/edit" do
    define_models :portfolios_controller
    
    before(:each) do
      @portfolio = mock_model(Portfolio)
      Portfolio.stub!(:find).and_return(@portfolio)
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
  
    it "should find the portfolio requested" do
      Portfolio.should_receive(:find).and_return(@portfolio)
      do_get
    end
  
    it "should assign the found Portfolio for the view" do
      do_get
      assigns[:portfolio].should equal(@portfolio)
    end
  end

  describe "handling POST /admin/portfolios" do
    define_models :portfolios_controller
    
    before(:each) do
      @portfolio = mock_model(Portfolio, :to_param => "1")
      Portfolio.stub!(:new).and_return(@portfolio)
    end
    
    describe "with successful save" do
      define_models :portfolios_controller
      
      def do_post
        @portfolio.should_receive(:save).and_return(true)
        post :create, :portfolio => {}
      end
  
      it "should create a new portfolio" do
        Portfolio.should_receive(:new).with({}).and_return(@portfolio)
        do_post
      end

      it "should redirect to the new portfolio" do
        do_post
        response.should redirect_to(admin_portfolio_url("1"))
      end
      
    end
    
    describe "with failed save" do
      define_models :portfolios_controller
      
      def do_post
        @portfolio.should_receive(:save).and_return(false)
        post :create, :portfolio => {}
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
      
    end
  end

  describe "handling PUT /admin/portfolios/1" do
    define_models :portfolios_controller
    
    before(:each) do
      @portfolio = mock_model(Portfolio, :to_param => "1")
      Portfolio.stub!(:find).and_return(@portfolio)
    end
    
    describe "with successful update" do
      define_models :portfolios_controller
      
      def do_put
        @portfolio.should_receive(:update_attributes).and_return(true)
        put :update, :id => "1"
      end

      it "should find the portfolio requested" do
        Portfolio.should_receive(:find).with("1").and_return(@portfolio)
        do_put
      end

      it "should update the found portfolio" do
        do_put
        assigns(:portfolio).should equal(@portfolio)
      end

      it "should assign the found portfolio for the view" do
        do_put
        assigns(:portfolio).should equal(@portfolio)
      end

      it "should redirect to the portfolio" do
        do_put
        response.should redirect_to(admin_portfolio_url("1"))
      end

    end
    
    describe "with failed update" do
      define_models :portfolios_controller
      
      def do_put
        @portfolio.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end

    end
  end

  describe "handling DELETE /admin/portfolios/1" do
    define_models :portfolios_controller
    
    before(:each) do
      @portfolio = mock_model(Portfolio, :destroy => true)
      Portfolio.stub!(:find).and_return(@portfolio)
    end
  
    def do_delete
      delete :destroy, :id => "1"
    end

    it "should find the portfolio requested" do
      Portfolio.should_receive(:find).with("1").and_return(@portfolio)
      do_delete
    end
  
    it "should call destroy on the found portfolio" do
      @portfolio.should_receive(:destroy)
      do_delete
    end
  
    it "should redirect to the portfolios list" do
      do_delete
      response.should redirect_to(admin_portfolios_url)
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :portfolios_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { get :edit, :id => portfolios(:one).id },
        lambda { put :update, :id => portfolios(:one).id, :portfolio => {} },
        lambda { get :new },
        lambda { post :create, :portfolio => {} },
        lambda { delete :destroy, :id => portfolios(:one).id }])
    end
    
    it "should require admin login" do
      test_login_requirement(true, false, [
        lambda { get :index },
        lambda { get :edit, :id => portfolios(:one).id },
        lambda { put :update, :id => portfolios(:one).id, :portfolio => {} },
        lambda { get :new },
        lambda { post :create, :portfolio => {} },
        lambda { delete :destroy, :id => portfolios(:one).id }])
    end
  end  
end
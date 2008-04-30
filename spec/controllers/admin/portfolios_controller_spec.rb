require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PortfoliosController do
  
  define_models :portfolios_controller do
    model Site do
      stub :other
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :parent_id => nil
      stub :two, :site => all_stubs(:site), :parent_id => nil
      stub :tre, :site => all_stubs(:other_site), :parent_id => nil
    end
  end
  
  before(:each) do
    activate_site(:default)
    login_as(:admin)
  end
    
  describe "handling GET /admin/portfolios" do
    define_models :portfolios_controller
    
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
  
    it "should assign the found portfolios for the view" do
      do_get
      assigns[:portfolios].should == sites(:default).portfolios
    end
  end

  describe "handling GET /admin/portfolios.xml" do
    define_models :portfolios_controller
    
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :index
    end
  
    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the found portfolios as xml" do
      do_get
      response.body.should == sites(:default).portfolios.to_xml
    end
  end

  describe "handling GET /admin/portfolios/1" do
    define_models :portfolios_controller
    
    def do_get
      get :show, :id => portfolios(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render show template" do
      do_get
      response.should render_template('show')
    end
  
    it "should assign the found portfolio for the view" do
      do_get
      assigns[:portfolio].should == portfolios(:one)
    end
    
    it "should render not found for portfolios not in the site" do
      get :show, :id => portfolios(:tre).id
      response.should be_missing
    end
  end

  describe "handling GET /admin/portfolios/1.xml" do
    define_models :portfolios_controller
    
    def do_get
      @request.env["HTTP_ACCEPT"] = "application/xml"
      get :show, :id => portfolios(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render the found portfolio as xml" do
      do_get
      response.body.should == portfolios(:one).to_xml
    end
  end

  describe "handling GET /admin/portfolios/new" do
    define_models :portfolios_controller
    
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
      do_get
      assigns[:portfolio].should be_new_record
    end
  
    it "should assign the new portfolio for the view" do
      do_get
      assigns[:portfolio].should be_an_instance_of(Portfolio)
    end
    
    it "should assign the site id to the new portfolio" do
      do_get
      assigns[:portfolio].site_id.should == sites(:default).id
    end
  end

  describe "handling GET /admin/portfolios/1/edit" do
    define_models :portfolios_controller
    
    def do_get
      get :edit, :id => portfolios(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should find the portfolio requested and assign it to the view" do
      do_get
      assigns[:portfolio].should == portfolios(:one)
    end
  
    it "should fail for portfolios that belong to another site" do
      get :edit, :id => portfolios(:tre).id
      response.should be_missing
    end
  end

  describe "handling POST /admin/portfolios" do
    define_models :portfolios_controller
    
    describe "with successful save" do
      define_models :portfolios_controller
      
      def do_post
        post :create, :portfolio => { :title => 'a_title' }
      end
  
      it "should create a new portfolio" do
        lambda { do_post }.should change(sites(:default).portfolios, :count).by(1)
      end

      it "should redirect to the portfolio list" do
        do_post
        response.should redirect_to(admin_portfolios_path)
      end
    end
    
    describe "with failed save" do
      define_models :portfolios_controller
      
      def do_post
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
    
    describe "with successful update" do
      define_models :portfolios_controller
      
      def do_put
        put :update, :id => portfolios(:one).id, :portfolio => { :title => 'haha' }
      end

      it "should update the found portfolio" do
        do_put
        assigns(:portfolio).reload.title.should == 'haha'
      end

      it "should assign the found portfolio for the view" do
        do_put
        assigns(:portfolio).should == portfolios(:one)
      end

      it "should redirect to the portfolio list" do
        do_put
        response.should redirect_to(admin_portfolios_path)
      end
    end
    
    describe "with failed update" do
      define_models :portfolios_controller
      
      def do_put
        put :update, :id => portfolios(:one).id, :portfolio => { :title => '012345678901234567890123456789012345678901234567890' }
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
    end
  end

  describe "handling DELETE /admin/portfolios/1" do
    define_models :portfolios_controller
    
    def do_delete
      delete :destroy, :id => portfolios(:one).id
    end

    it "should call destroy on the found portfolio" do
      lambda { do_delete }.should change(Portfolio, :count).by(-1)
    end
  
    it "should redirect to the portfolios list" do
      do_delete
      response.should redirect_to(admin_portfolios_url)
    end
    
    it "should not delete portfolios that are not part of the site" do
      lambda { delete :destroy, :id => portfolios(:tre).id }.should_not change(Portfolio, :count)
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
require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ResumeSectionsController do

  define_models :resume_sections_controller do
    model ResumeSection do
      stub :one, :site => all_stubs(:site), :position => 1
      stub :two, :site => all_stubs(:site), :position => 2
      stub :tre, :site => all_stubs(:site), :position => 3
      stub :four, :site => all_stubs(:other_site), :position => 1
    end
  end
  
  before(:each) do
    activate_site(:default)
    
    # Create a few cache items.
    @a = CacheItem.for(sites(:default), 'a', [resume_sections(:one)])
    @b = CacheItem.for(sites(:default), 'b', [sites(:default)])
    @c = CacheItem.for(sites(:default), 'c', [resume_sections(:one), sites(:default)])
    @d = CacheItem.for(sites(:default), 'd', [sites(:default).resume_sections])
    @e = CacheItem.for(sites(:default), 'e', [resume_sections(:two)])
  end

  describe "handling GET /admin/resume_sections" do
    define_models :resume_sections_controller

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
  
    it "should assign the found resume_sections for the view" do
      do_get
      assigns[:resume_sections].should == sites(:default).resume_sections
    end
  end

  describe "handling GET /admin/resume_sections.xml" do
    define_models :resume_sections_controller
    
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

    it "should render the found resume_sections as xml" do
      do_get
      response.body.should == sites(:default).resume_sections.to_xml
    end
  end

  describe "handling GET /admin_resume_sections/new" do
    define_models :resume_sections_controller
    
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
  
    it "should create an new resume_section" do
      do_get
      assigns[:resume_section].should be_an_instance_of(ResumeSection)
    end
  
    it "should not save the new resume_section" do
      do_get
      assigns[:resume_section].should be_new_record
    end
  end

  describe "handling GET /admin/resume_sections/1/edit" do
    define_models :resume_sections_controller
    
    before(:each) do
      login_as :admin
    end
  
    def do_get
      get :edit, :id => resume_sections(:one)
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should assign the found Admin::ResumeSection for the view" do
      do_get
      assigns[:resume_section].should == resume_sections(:one)
    end
    
    it "should be missing for sections that are not in the site" do
      get :edit, :id => resume_sections(:four)
      response.should be_missing
    end
  end

  describe "handling POST /admin/resume_sections" do
    define_models :resume_sections_controller

    before(:each) do
      login_as :admin
    end
    
    describe "with successful save" do
      define_models :resume_sections_controller
      
      def do_post
        post :create, :resume_section => { :title => 'education' }
      end
  
      it "should create a new resume_section" do
        lambda { do_post }.should change(sites(:default).resume_sections, :count).by(1)
      end

      it "should redirect to the newly created section" do
        do_post
        response.should redirect_to(edit_admin_resume_section_path(ResumeSection.find_by_title('education')))
      end
      
      it "should set the position of the new section to be at the end of the list" do
        do_post
        ResumeSection.find_by_title('education').position.should == 4
      end 
      
      it "should expire caches related to the list of sections" do
        lambda { do_post }.should expire([@d])
      end
    end
    
    describe "with failed save" do
      define_models :resume_sections_controller
      
      def do_post
        post :create, :resume_section => { }
      end
  
      it "should not create a new resume section" do
        lambda { do_post }.should_not change(sites(:default).resume_sections, :count)
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end
    end
  end

  describe "handling PUT /admin/resume_sections/1" do
    define_models :resume_sections_controller

    before(:each) do
      login_as :admin
    end
    
    describe "with successful update" do
      define_models :resume_sections_controller
      
      def do_put
        put :update, :id => resume_sections(:one).id, :resume_section => { :title => 'ack' }
      end

      it "should find the resume_section requested" do
        do_put
        assigns[:resume_section].should == resume_sections(:one)
      end

      it "should update the found resume_section" do
        do_put
        assigns(:resume_section).title.should == 'ack'
      end

      it "should redirect to the resume_section list" do
        do_put
        response.should redirect_to(admin_resume_sections_path)
      end

      it "should render missing for sections not in the site" do
        put :update, :id => resume_sections(:four).id
        response.should be_missing
      end
      
      it "should expire caches related to the section" do
        lambda { do_put }.should expire([@a, @c])
      end
    end
    
    describe "with failed update" do
      define_models :resume_sections_controller

      def do_put
        put :update, :id => resume_sections(:one).id, :resume_section => { }
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
    end
  end

  describe "handling PUT /links/reorder" do
    define_models :resume_sections_controller

    before(:each) do
      login_as(:admin)
    end

    def do_put
      put :reorder, :resume_sections => [ resume_sections(:tre).id, resume_sections(:one).id, resume_sections(:two).id ]
    end

    it "should render nothing" do
      do_put
      response.should be_success
      response.body.should be_blank
    end

    it "should update the resume section order" do
      do_put
      sites(:default).resume_sections.reload.should == [ resume_sections(:tre), resume_sections(:one), resume_sections(:two) ]
    end
    
    it "should expire caches related to the section" do
      lambda { do_put }.should expire([@a, @c, @e])
    end
  end

  describe "handling DELETE /admin/resume_sections/1" do
    define_models :resume_sections_controller

    before(:each) do
      login_as :admin
    end
  
    def do_delete
      delete :destroy, :id => resume_sections(:one).id
    end

    it "should call destroy on the found resume_section" do
      do_delete
      ResumeSection.find_by_id(resume_sections(:one).id).should be_nil
    end
  
    it "should redirect to the admin_resume_sections list" do
      do_delete
      response.should redirect_to(admin_resume_sections_url)
    end
    
    it "should expire caches related to the section and the list of sections" do
      lambda { do_delete }.should expire([@a, @c, @d])
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :resume_sections_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :index },
        lambda { get :edit, :id => resume_sections(:one).id },
        lambda { put :update, :id => resume_sections(:one).id, :resume_section => {} },
        # lambda { put :reorder },
        lambda { get :new },
        lambda { post :create, :resume_section => {} },
        lambda { delete :destroy, :id => resume_sections(:one).id }])
    end
    
    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :index },
        lambda { get :edit, :id => resume_sections(:one).id },
        lambda { put :update, :id => resume_sections(:one).id, :resume_section => {} },
        # lambda { put :reorder },
        lambda { get :new },
        lambda { post :create, :resume_section => {} },
        lambda { delete :destroy, :id => resume_sections(:one).id }])
    end
  end
end
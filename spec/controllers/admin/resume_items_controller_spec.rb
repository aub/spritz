require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ResumeItemsController do

  define_models :resume_items_controller do
    model ResumeSection do
      stub :one, :site => all_stubs(:site)
      stub :two, :site => all_stubs(:site)
    end
    model ResumeItem do
      stub :one, :resume_section => all_stubs(:one_resume_section), :position => 1
      stub :two, :resume_section => all_stubs(:one_resume_section), :position => 2
      stub :tre, :resume_section => all_stubs(:one_resume_section), :position => 3
      stub :four, :resume_section => all_stubs(:two_resume_section), :position => 1
    end
  end
  
  before(:each) do
    activate_site(:default)

    # Create a few cache items.
    @a = CacheItem.for(sites(:default), 'a', [resume_items(:one)])
    @b = CacheItem.for(sites(:default), 'b', [resume_sections(:one)])
    @c = CacheItem.for(sites(:default), 'c', [resume_items(:one), sites(:default)])
    @d = CacheItem.for(sites(:default), 'd', [resume_sections(:one).resume_items])
    @e = CacheItem.for(sites(:default), 'e', [resume_items(:two)])
  end
  
  describe "handling GET /admin/resume_sections/1/resume_items/new" do
    define_models :resume_items_controller

    before(:each) do
      login_as :admin
    end
  
    def do_get
      get :new, :resume_section_id => resume_sections(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render new template" do
      do_get
      response.should render_template('new')
    end
  
    it "should create an new resume_item" do
      do_get
      assigns(:resume_item).should be_new_record
    end  
  end

  describe "handling GET /admin/resume_sections/1/resume_items/1/edit" do
    define_models :resume_items_controller

    before(:each) do
      login_as :admin
    end
  
    def do_get
      get :edit, :id => resume_items(:one).id, :resume_section_id => resume_sections(:one).id
    end

    it "should be successful" do
      do_get
      response.should be_success
    end
  
    it "should render edit template" do
      do_get
      response.should render_template('edit')
    end
  
    it "should assign the found resume_item for the view" do
      do_get
      assigns[:resume_item].should == resume_items(:one)
    end
    
    it "should return missing for items in a different section" do
      get :edit, :id => resume_items(:four).id, :resume_section_id => resume_sections(:one).id
      response.should be_missing
    end
  end

  describe "handling POST /admin/resume_sections/1/resume_items" do
    define_models :resume_items_controller

    before(:each) do
      login_as :admin
    end
    
    describe "with successful save" do
      define_models :resume_items_controller
  
      def do_post
        post :create, :resume_item => { :text => 'ack' }, :resume_section_id => resume_sections(:one).id
      end
  
      it "should create a new resume_item" do
        do_post
        ResumeItem.find_by_text('ack').should_not be_nil
      end

      it "should redirect to the resume_section" do
        do_post
        response.should redirect_to(edit_admin_resume_section_path(resume_sections(:one)))
      end
      
      it "should expire caches related to the section's list of items" do
        lambda { do_post }.should expire([@d])
      end
    end
    
    describe "with failed save" do
      define_models :resume_items_controller

      def do_post
        post :create, :resume_item => {}, :resume_section_id => resume_sections(:one).id
      end
  
      it "should re-render 'new'" do
        do_post
        response.should render_template('new')
      end

      it "should not create a resume item" do
        lambda { do_post }.should_not change(ResumeItem, :count)
      end
    end
  end

  describe "handling PUT /admin/resume_sections/1/resume_items/1" do
    define_models :resume_items_controller

    before(:each) do
      login_as :admin
    end
    
    describe "with successful update" do
      define_models :resume_items_controller

      def do_put
        put :update, :id => resume_items(:one).id, :resume_section_id => resume_sections(:one).id, :resume_item => { :text => 'hooya' }
      end

      it "should update the found resume_item" do
        do_put
        resume_items(:one).reload.text.should == 'hooya'
      end

      it "should assign the found resume_item for the view" do
        do_put
        assigns(:resume_item).should == resume_items(:one)
      end

      it "should redirect to editing the resume_section" do
        do_put
        response.should redirect_to(edit_admin_resume_section_path(resume_sections(:one)))
      end
      
      it "should expire caches related to the item" do
        lambda { do_put }.should expire([@a, @c])
      end
    end
    
    describe "with failed update" do
      define_models :resume_items_controller

      def do_put
        put :update, :id => resume_items(:one).id, :resume_section_id => resume_sections(:one).id, :resume_item => { :text => '' }
      end

      it "should re-render 'edit'" do
        do_put
        response.should render_template('edit')
      end
    end
  end

  describe "handling DELETE /admin/resume_sections/1/resume_items/1" do
    define_models :resume_items_controller

    before(:each) do
      login_as :admin
    end
  
    def do_delete
      delete :destroy, :id => resume_items(:one).id, :resume_section_id => resume_sections(:one).id
    end

    it "should call destroy on the found resume_item" do
      do_delete
      resume_sections(:one).resume_items.include?(resume_items(:one).id).should be_false
    end
  
    it "should redirect to editing the resume section" do
      do_delete
      response.should redirect_to(edit_admin_resume_section_path(resume_sections(:one)))
    end
    
    it "should expire caches related to the item and the list of items" do
      lambda { do_delete }.should expire([@a, @c, @d])
    end
  end
  
  describe "handling PUT /resume_items/reorder" do
    define_models :resume_items_controller

    before(:each) do
      login_as(:admin)
    end

    def do_put
      put :reorder, :resume_items => [ resume_items(:tre).id, resume_items(:one).id, resume_items(:two).id ], :resume_section_id => resume_sections(:one).id
    end

    it "should render nothing" do
      do_put
      response.should be_success
      response.body.should be_blank
    end

    it "should update the item order" do
      do_put
      resume_sections(:one).resume_items.reload.should == [ resume_items(:tre), resume_items(:one), resume_items(:two) ]
    end
    
    it "should expire caches related to the item" do
      lambda { do_put }.should expire([@a, @c, @e])
    end
  end
  
  describe "site, login, and admin requirements" do
    define_models :resume_items_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :edit, :id => resume_items(:one).id, :resume_section_id => resume_sections(:one).id },
        lambda { put :update, :id => resume_items(:one).id, :resume_item => {}, :resume_section_id => resume_sections(:one).id },
        lambda { put :reorder, :resume_section_id => resume_sections(:one).id },
        lambda { get :new, :resume_section_id => resume_sections(:one).id },
        lambda { post :create, :resume_item => {}, :resume_section_id => resume_sections(:one).id },
        lambda { delete :destroy, :id => resume_items(:one).id, :resume_section_id => resume_sections(:one).id }])
    end
    
    it "should require normal login" do
      test_login_requirement(true, false, [
        lambda { get :edit, :id => resume_items(:one).id, :resume_section_id => resume_sections(:one).id },
        lambda { put :update, :id => resume_items(:one).id, :resume_item => {}, :resume_section_id => resume_sections(:one).id },
        lambda { put :reorder, :resume_section_id => resume_sections(:one).id },
        lambda { get :new, :resume_section_id => resume_sections(:one).id },
        lambda { post :create, :resume_item => {}, :resume_section_id => resume_sections(:one).id },
        lambda { delete :destroy, :id => resume_items(:one).id, :resume_section_id => resume_sections(:one).id }])
    end
  end
end
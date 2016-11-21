require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ResumeItemsController do
  describe "route generation" do

    it "should map { :controller => 'admin/resume_items', :action => 'index', :resume_section_id => '1' } to /admin/resume_sections/1/resume_items" do
      route_for(:controller => "admin/resume_items", :action => "index", :resume_section_id => '1').should == "/admin/resume_sections/1/resume_items"
    end
  
    it "should map { :controller => 'admin/resume_items', :action => 'new', :resume_section_id => '1' } to /admin/resume_sections/1/resume_items/new" do
      route_for(:controller => "admin/resume_items", :action => "new", :resume_section_id => '1').should == "/admin/resume_sections/1/resume_items/new"
    end

    it "should map { :controller => 'admin/resume_items', :action => 'create', :resume_section_id => '1' } to /admin/resume_sections/1/resume_items" do
      route_for(:controller => "admin/resume_items", :action => "create", :resume_section_id => '1').should == "/admin/resume_sections/1/resume_items"
    end
  
    it "should map { :controller => 'admin/resume_items', :action => 'show', :id => 1, :resume_section_id => '1' } to /admin/resume_sections/1/resume_items/1" do
      route_for(:controller => "admin/resume_items", :action => "show", :id => 1, :resume_section_id => '1').should == "/admin/resume_sections/1/resume_items/1"
    end
  
    it "should map { :controller => 'admin/resume_items', :action => 'edit', :id => 1, :resume_section_id => '1' } to /admin/resume_sections/1/resume_items/1/edit" do
      route_for(:controller => "admin/resume_items", :action => "edit", :id => 1, :resume_section_id => '1').should == "/admin/resume_sections/1/resume_items/1/edit"
    end
  
    it "should map { :controller => 'admin/resume_items', :action => 'update', :id => 1, :resume_section_id => '1'} to /admin/resume_sections/1/resume_items/1" do
      route_for(:controller => "admin/resume_items", :action => "update", :id => 1, :resume_section_id => '1').should == "/admin/resume_sections/1/resume_items/1"
    end
  
    it "should map { :controller => 'admin/resume_items', :action => 'destroy', :id => 1, :resume_section_id => '1'} to /admin/resume_sections/1/resume_items/1" do
      route_for(:controller => "admin/resume_items", :action => "destroy", :id => 1, :resume_section_id => '1').should == "/admin/resume_sections/1/resume_items/1"
    end
    
    it "should map { :controller => 'admin/resume_items', :action => 'reorder', :resume_section_id => '1'} to /admin/resume_sections/1/resume_items/reorder" do
      route_for(:controller => "admin/resume_items", :action => "reorder", :resume_section_id => '1').should == "/admin/resume_sections/1/resume_items/reorder"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/resume_items', action => 'index', :resume_section_id => '1' } from GET /admin/resume_sections/1/resume_items" do
      params_from(:get, "/admin/resume_sections/1/resume_items").should == {:controller => "admin/resume_items", :action => "index", :resume_section_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resume_items', action => 'new', :resume_section_id => '1' } from GET /admin/resume_sections/1/resume_items/new" do
      params_from(:get, "/admin/resume_sections/1/resume_items/new").should == {:controller => "admin/resume_items", :action => "new", :resume_section_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resume_items', action => 'create', :resume_section_id => '1' } from POST /admin/resume_sections/1/resume_items" do
      params_from(:post, "/admin/resume_sections/1/resume_items").should == {:controller => "admin/resume_items", :action => "create", :resume_section_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resume_items', action => 'show', id => '1', :resume_section_id => '1' } from GET /admin/resume_sections/1/resume_items/1" do
      params_from(:get, "/admin/resume_sections/1/resume_items/1").should == {:controller => "admin/resume_items", :action => "show", :id => "1", :resume_section_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resume_items', action => 'edit', id => '1', :resume_section_id => '1' } from GET /admin/resume_sections/1/resume_items/1;edit" do
      params_from(:get, "/admin/resume_sections/1/resume_items/1/edit").should == {:controller => "admin/resume_items", :action => "edit", :id => "1", :resume_section_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resume_items', action => 'update', id => '1', :resume_section_id => '1' } from PUT /admin/resume_sections/1/resume_items/1" do
      params_from(:put, "/admin/resume_sections/1/resume_items/1").should == {:controller => "admin/resume_items", :action => "update", :id => "1", :resume_section_id => '1'}
    end
  
    it "should generate params { :controller => 'admin/resume_items', action => 'destroy', id => '1', :resume_section_id => '1' } from DELETE /admin/resume_sections/1/resume_items/1" do
      params_from(:delete, "/admin/resume_sections/1/resume_items/1").should == {:controller => "admin/resume_items", :action => "destroy", :id => "1", :resume_section_id => '1'}
    end
    
    it "should generate params { :controller => 'admin/resume_items', action => 'reorder', :resume_section_id => '1' } from PUT /admin/resume_sections/1/resume_items/reorder" do
      params_from(:put, "/admin/resume_sections/1/resume_items/reorder").should == {:controller => "admin/resume_items", :action => "reorder", :resume_section_id => '1'}
    end
  end
end
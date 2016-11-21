require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::ResumeSectionsController do
  describe "route generation" do

    it "should map { :controller => 'admin/resume_sections', :action => 'index' } to /admin/resume_sections" do
      route_for(:controller => "admin/resume_sections", :action => "index").should == "/admin/resume_sections"
    end
  
    it "should map { :controller => 'admin/resume_sections', :action => 'new' } to /admin/resume_sections/new" do
      route_for(:controller => "admin/resume_sections", :action => "new").should == "/admin/resume_sections/new"
    end
  
    it "should map { :controller => 'admin/resume_sections', :action => 'show', :id => 1 } to /admin/resume_sections/1" do
      route_for(:controller => "admin/resume_sections", :action => "show", :id => 1).should == "/admin/resume_sections/1"
    end
  
    it "should map { :controller => 'admin/resume_sections', :action => 'edit', :id => 1 } to /admin/resume_sections/1/edit" do
      route_for(:controller => "admin/resume_sections", :action => "edit", :id => 1).should == "/admin/resume_sections/1/edit"
    end
  
    it "should map { :controller => 'admin/resume_sections', :action => 'update', :id => 1} to /admin/resume_sections/1" do
      route_for(:controller => "admin/resume_sections", :action => "update", :id => 1).should == "/admin/resume_sections/1"
    end
  
    it "should map { :controller => 'admin/resume_sections', :action => 'destroy', :id => 1} to /admin/resume_sections/1" do
      route_for(:controller => "admin/resume_sections", :action => "destroy", :id => 1).should == "/admin/resume_sections/1"
    end
    
    it "should map { :controller => 'admin/resume_sections', :action => 'reorder'} to /admin/resume_sections/reorder" do
      route_for(:controller => "admin/resume_sections", :action => "reorder").should == "/admin/resume_sections/reorder"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'admin/resume_sections', action => 'index' } from GET /admin/resume_sections" do
      params_from(:get, "/admin/resume_sections").should == {:controller => "admin/resume_sections", :action => "index"}
    end
  
    it "should generate params { :controller => 'admin/resume_sections', action => 'new' } from GET /admin/resume_sections/new" do
      params_from(:get, "/admin/resume_sections/new").should == {:controller => "admin/resume_sections", :action => "new"}
    end
  
    it "should generate params { :controller => 'admin/resume_sections', action => 'create' } from POST /admin/resume_sections" do
      params_from(:post, "/admin/resume_sections").should == {:controller => "admin/resume_sections", :action => "create"}
    end
  
    it "should generate params { :controller => 'admin/resume_sections', action => 'show', id => '1' } from GET /admin/resume_sections/1" do
      params_from(:get, "/admin/resume_sections/1").should == {:controller => "admin/resume_sections", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/resume_sections', action => 'edit', id => '1' } from GET /admin/resume_sections/1;edit" do
      params_from(:get, "/admin/resume_sections/1/edit").should == {:controller => "admin/resume_sections", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/resume_sections', action => 'update', id => '1' } from PUT /admin/resume_sections/1" do
      params_from(:put, "/admin/resume_sections/1").should == {:controller => "admin/resume_sections", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => 'admin/resume_sections', action => 'destroy', id => '1' } from DELETE /admin/resume_sections/1" do
      params_from(:delete, "/admin/resume_sections/1").should == {:controller => "admin/resume_sections", :action => "destroy", :id => "1"}
    end
    
    it "should generate params { :controller => 'admin/resume_sections', action => 'reorder' } from PUT /admin/resume_sections/reorder" do
      params_from(:put, "/admin/resume_sections/reorder").should == {:controller => "admin/resume_sections", :action => "reorder"}
    end
  end
end
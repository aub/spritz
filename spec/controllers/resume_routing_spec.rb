require File.dirname(__FILE__) + '/../spec_helper'

describe ResumeController do
  describe "route generation" do

    it "should map { :controller => 'resume', :action => 'show' } to /resume" do
      route_for(:controller => "resume", :action => "show").should == "/resume"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => 'resume', action => 'show' } from GET /resume" do
      params_from(:get, "/resume").should == { :controller => "resume", :action => "show" }
    end
  end
end
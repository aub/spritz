require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sessions/new.html.haml" do
  include Admin::SessionsHelper
  
  define_models
  
  before(:each) do
    assigns[:site] = sites(:default)
    render "/admin/sessions/new.html.haml"
  end

  it "should have an input for the login name" do
    response.should have_tag('input[id=login][type=text][name=login]')
  end

  it "should have an input for the password name" do
    response.should have_tag('input[id=password][type=password][name=password]')
  end
  
  it "should have a remember-me check box" do
    response.should have_tag('input[id=remember_me][type=checkbox][name=remember_me]')
  end
  
  it "should have a submit button" do
    response.should have_tag('input[type=submit][name=commit]')
  end
  
end
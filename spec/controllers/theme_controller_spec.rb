require File.dirname(__FILE__) + '/../spec_helper'

describe ThemeController do
  define_models :theme_controller

  before(:each) do
    activate_site(:default)
  end
  
  describe "site, login, and admin requirements" do
    define_models :theme_controller
    
    it "should require a site" do
      test_site_requirement(true, [
        lambda { get :stylesheets, :filename => 'f', :ext => 'css' },
        lambda { get :images, :filename => 'f', :ext => 'png' },
        lambda { get :javascripts, :filename => 'f', :ext => 'js' }])
    end
        
    it "should not require login" do
      test_login_requirement(false, false, [
        lambda { get :stylesheets, :filename => 'f', :ext => 'css' },
        lambda { get :images, :filename => 'f', :ext => 'png' },
        lambda { get :javascripts, :filename => 'f', :ext => 'js' }])
    end
  end
  
  describe "rendering files" do    
    define_models :theme_controller
    
    it "should render not found if the path contains .. (for safety)" do
      get :stylesheets, :filename => 'a/b/../c', :ext => 'css'
      response.should be_missing
    end
    
    it "should return not found if the file doesn't exist" do
      p = mock_model(Pathname)
      p.stub!(:file?).and_return(false)
      Pathname.stub!(:new).and_return(p)
      get :images, :filename => 'f', :ext => 'png'
      response.should be_missing
    end

    describe "with a file that exists" do
      define_models :theme_controller
      
      before(:each) do
        p = mock_model(Pathname)
        p.stub!(:file?).and_return(true)
        p.stub!(:read).and_return('abc')
        p.stub!(:basename).and_return('fake_name')
        Pathname.stub!(:new).and_return(p)        
      end
      
      it "should render correctly when the css resource exists" do
        get :stylesheets, :filename => 'f', :ext => 'css'
        response.body.should == 'abc'
      end
      
      it "should set the correct type for css" do
        get :stylesheets, :filename => 'f', :ext => 'css'
        response.headers['type'].should == 'text/css; charset=utf-8'
      end

      it "should render correctly when the javascript resource exists" do
        get :javascripts, :filename => 'f', :ext => 'js'
        response.body.should == 'abc'
      end
      
      it "should set the correct type for javascript" do
        get :javascripts, :filename => 'f', :ext => 'js'
        response.headers['type'].should == 'text/javascript; charset=utf-8'        
      end
      
      describe "when rendering images" do
        define_models :theme_controller
        
        it "should set the correct headers" do
          get :images, :filename => 'f', :ext => 'png'
          { 'Content-Transfer-Encoding' => 'binary', 'Content-Disposition' => 'inline; filename="fake_name"',
            'Cache-Control' => 'private' }.each do |key, value|
             response.headers[key].should == value 
          end
        end
        
        it "should render correctly when the png resource exists" do
          get :images, :filename => 'f', :ext => 'png'
          response.body.should == 'abc'
        end
        
        it "should set the correct type for png" do
          get :images, :filename => 'f', :ext => 'png'
          response.headers['type'].should == 'image/png'
        end
        
        it "should render correctly when the jpg resource exists" do
          get :images, :filename => 'f', :ext => 'jpg'
          response.body.should == 'abc'
        end
        
        it "should set the correct type for jpg" do
          get :images, :filename => 'f', :ext => 'jpg'
          response.headers['type'].should == 'image/jpeg'
        end

        it "should render correctly when the gif resource exists" do
          get :images, :filename => 'f', :ext => 'gif'
          response.body.should == 'abc'
        end
        
        it "should set the correct type for gif" do
          get :images, :filename => 'f', :ext => 'gif'
          response.headers['type'].should == 'image/gif'
        end
        
        it "should be successful even if the type is random" do
          get :images, :filename => 'f', :ext => 'random'
          response.body.should == 'abc'
        end
        
        it "should set the correct headers when the type is random" do
          get :images, :filename => 'f', :ext => 'random'
          response.headers['type'].should == 'application/binary'
        end        
      end
    end    
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe Resource do
  define_models :resource
  
  before(:each) do
    @theme = Theme.new('hack', sites(:default))
  end
  
  it "should require a theme and a path to create one" do
    Resource.new(@theme, 'a/b/c').should be_an_instance_of(Resource)
  end
  
  describe "getting the name for the resource" do
    define_models :resource
    
    it "should be the file name" do
      Resource.new(@theme, Pathname.new('a/b/c')).name.should == 'c'
    end
    
    it "should remove spaces from the path" do
      Resource.new(@theme, Pathname.new('a/b/c  ')).name.should == 'c'
    end
    
    it "should remove junk from the path" do
      Resource.new(@theme, Pathname.new('a/b/ cde!@# f$% g^ &*(.css ')).name.should == 'cde-f-g-css'
    end
    
    it "should convert reasonable things as well" do
      Resource.new(@theme, Pathname.new('a/b/cde.css')).name.should == 'cde-css'
    end
    
    it "should alias name as to_param" do
      Resource.new(@theme, Pathname.new('a/b/cde.css')).to_param.should == 'cde-css'
    end
    
    it "should have another method that just returns the raw file name" do
      Resource.new(@theme, Pathname.new('a/b/cde.css')).filename.should == 'cde.css'
    end
  end
  
  describe "working with the data in the resources and their files" do
    define_models :resource
    
    # This will copy over the theme data
    before(:each) do
      Theme.create_defaults_for(sites(:default))
      sites(:default).update_attribute(:theme_path, 'dark')
    end

    after(:each) do
      cleanup_theme_directory
    end
    
    it "should update the file on write" do
      resource = sites(:default).theme.resources.first
      resource.write('happy days')
      File.open(resource.path, 'r').read.should == 'happy days'
    end
    
    it "should read the file" do
      resource = sites(:default).theme.resources.first
      resource.write('happy days')
      resource.read.should == 'happy days'
    end
    
    it "should identify files that are images" do
      sites(:default).theme.resource('test-jpg').should be_image
    end
    
    it "should identify files that are not images" do
      sites(:default).theme.resource('home-liquid').should_not be_image
    end
    
    it "should allow deletion" do
      resource = sites(:default).theme.resources.first
      File.exist?(resource.path).should be_true
      resource.destroy
      File.exist?(resource.path).should be_false
    end
    
    it "should remove itself from the theme's resources on deletion" do
      old_size = sites(:default).theme.resources.size
      sites(:default).theme.resources.first.destroy
      sites(:default).theme.resources.size.should == old_size - 1
    end
    
    it "should identify files that are templates" do
      sites(:default).theme.resource('home-liquid').should be_template
    end
    
    it "should identify files that are not templates" do
      sites(:default).theme.resource('test-jpg').should_not be_template
    end
    
    it "should identify files that are stylesheets" do
      sites(:default).theme.resource('styles-css').should be_stylesheet
    end
    
    it "should identify files that are not stylesheets" do
      sites(:default).theme.resource('test-jpg').should_not be_stylesheet
    end
    
    it "should identify files that are javascript" do
      sites(:default).theme.resource('scripts-js').should be_javascript
    end
    
    it "should identify files that are not javascript" do
      sites(:default).theme.resource('test-jpg').should_not be_javascript
    end
  end
end
